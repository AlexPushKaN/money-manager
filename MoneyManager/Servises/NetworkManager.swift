import UIKit
import Network

class NetworkManager {
    
    let appID = "0fcdb415e3b24df59154358a053feb7e" // Токен для авторизации на https://openexchangerates.org/api/
    let host = NWEndpoint.Host("https://openexchangerates.org")
    var isInternetAvailable: Bool = true
    
    init() {
        
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "network-monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isInternetAvailable = (path.status == .satisfied)
        }
    }
    
    func getDataFromNetwork(parametersQueries: String, controller: UIViewController?, completionHandler: @escaping (DataFromNetwork) -> Void) -> UIAlertController? {
        
        if !isInternetAvailable {
            let alert = Alerts.show(alert: .isInternetAvailable, title: "Отсутствует соединение с сетью Интернет", message: "Проверьте соединение с сетью Интернет и повторите попытку") { noInternetAccess in
                if noInternetAccess {
                    if let controller = controller as? SettingsViewController {
                        controller.isInternetAvailable = false
                        controller.dismiss(animated: true)
                    }
                }
            }
            return alert
        }
        
        let baseCurrency: String = "USD" //используем в качестве параметра baseCurrency бесплатный вариант с USD в качестве базовой валюты для запроса
        let queryString: String = "base=\(baseCurrency)&symbols=" + parametersQueries
        let url: URL = URL(string: "https://openexchangerates.org/api/latest.json?\(queryString)")!
        
        var request = URLRequest(url: url)
        request.setValue("Token \(appID)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(String(describing: error.localizedDescription))
            } else if let response = response as? HTTPURLResponse, response.statusCode / 100 == 2 {
                do {
                    guard let data = data else { return }
                    let decoder = JSONDecoder()
                    let currencies = try decoder.decode(DataFromNetwork.self, from: data)
                    completionHandler(currencies)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
            } else {
                print("Invalid response or status code")
            }
        }
        task.resume()
        return nil
    }
}

