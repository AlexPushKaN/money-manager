import Foundation

extension ListOfCurrencies {

    static var listOfCurrenciesDefaultsKey = "listOfCurrenciesDefaultsKey"

    static func save(information listOfCurrencies: ListOfCurrencies) {
        do {
            let data = try JSONEncoder().encode(listOfCurrencies)
            UserDefaults.standard.set(data, forKey: listOfCurrenciesDefaultsKey)
        } catch {
            print("file save error!")
        }
    }

    static func loadInformation() -> ListOfCurrencies {
        var information: ListOfCurrencies = ListOfCurrencies()
        if let data = UserDefaults.standard.data(forKey: listOfCurrenciesDefaultsKey) {
            do {
                information = try JSONDecoder().decode(ListOfCurrencies.self, from: data)
            } catch {
                print("file upload error!")
            }
        }
        return information
    }
}
