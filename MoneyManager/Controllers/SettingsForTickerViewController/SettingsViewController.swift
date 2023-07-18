import UIKit

class SettingsViewController: UIViewController {
    
    var logoImageView: UIImageView? = nil
    var urlSourseLabel: UILabel? = nil
    var settlementСurrencyLabel: UILabel? = nil
    var settlementСurrencyPickerView: UIPickerView? = nil
    var listLabel: UILabel? = nil
    var updateDataButton: UIButton? = nil
    var currenciesTableView: UITableView? = nil
    var resetListCurrenciesButton: UIButton? = nil
    
    var listOfCurrencies: ListOfCurrencies = ListOfCurrencies()
    var selectedCurrencyFromList: ListOfCurrencies = ListOfCurrencies.loadInformation()
    let networkManager = NetworkManager()
    
    lazy var isInternetAvailable: Bool = {
        return networkManager.isInternetAvailable
    }()
    var ifNeedUpdate: Bool = false
    
    var listElement: CurrencyInformation?
    var parametersQueries: String = ""
    var settlementСurrency: Int = 0 {
        didSet {
            parametersQueries = parametersQueries.replacingOccurrences(of: ListSymbolsAndNamesCurrency.allCases[oldValue].rawValue + ",", with: "")
        }
        willSet {
            parametersQueries += ListSymbolsAndNamesCurrency.allCases[newValue].rawValue + ","
        }
    }

    override func loadView() {
        super.loadView()
        
        let allCurrencies = ListSymbolsAndNamesCurrency.RUB.getAllNameAndSymbol()
        for oneOf in allCurrencies {
            var nextIteration: Bool = false
            for selectedCurrency in selectedCurrencyFromList.all {
                if oneOf.key == selectedCurrency.currencySymbol {
                    listOfCurrencies.all.append(selectedCurrency)
                    nextIteration = true
                    break
                }
            }
            
            if !nextIteration {
                let currencyInformation = CurrencyInformation(currencySymbol: oneOf.key, currencyName: oneOf.value, statusInListOfCurrencies: false)
                listOfCurrencies.all.append(currencyInformation)
            }
        }
        
        listOfCurrencies.all.sort { symbol1, symbol2 in
            symbol1.currencySymbol < symbol2.currencySymbol
        }
        
        settlementСurrency = selectedCurrencyFromList.settlementСurrency
        listElement = listOfCurrencies.all.remove(at: settlementСurrency)
        parametersQueries += selectedCurrencyFromList.all.map{ $0.currencySymbol + "," }.joined()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .incomesViewControllerColor.withAlphaComponent(0.7)

        customizeLogoImageView()
        customizeUrlSourseLabel()
        customizeSettlementСurrencyLabel()
        customizeSettlementСurrencyPickerView()
        customizeListLabel()
        customizeUpdateDataButton()
        customizeTableView()
        customizeResetListCurrenciesButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let updateDataButton = updateDataButton,
           let resetListCurrenciesButton = resetListCurrenciesButton {
            updateDataButton.layer.cornerRadius = updateDataButton.frame.height / 2
            resetListCurrenciesButton.layer.cornerRadius = resetListCurrenciesButton.frame.height / 2
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settlementСurrencyPickerView?.selectRow(settlementСurrency, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        listOfCurrencies.settlementСurrency = settlementСurrency
        ListOfCurrencies.save(information: listOfCurrencies)
        
        if let controller = presentingViewController?.children[0] as? IncomesViewController {
            if listOfCurrencies.all.count > 0 && ifNeedUpdate && isInternetAvailable {
                controller.tickerView.labels = []
                controller.tickerView.create(labelsForTicker: listOfCurrencies)
                controller.startTickerAnimate(andSettingsTickerButton: false)
            } else if listOfCurrencies.all.count > 0 && ifNeedUpdate == false && isInternetAvailable == false {
                controller.tickerView.labels = []
                controller.tickerView.create(labelsForTicker: listOfCurrencies)
                controller.startTickerAnimate(andSettingsTickerButton: false)
            } else if ifNeedUpdate == false {
                return
            } else if ifNeedUpdate == true {
                controller.tickerView.subviews.forEach{ $0.removeFromSuperview() }
            }
        }
    }
    
    @objc func updateCurrencyList(_ sender: UIButton) {

        sender.isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.isSelected = false
        }
        
        if !parametersQueries.isEmpty {
            ifNeedUpdate = true
            update(byParameters: parametersQueries)
        }
    }

    @objc func resetCurrencyList(_ sender: UIButton) {
        
        sender.isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.isSelected = false
        }
        
        for currencyInformation in listOfCurrencies.all {
            if currencyInformation.statusInListOfCurrencies {
                currencyInformation.statusInListOfCurrencies = false
            }
        }
        
        if let currenciesTableView = currenciesTableView {
            selectedCurrencyFromList.all = []
            ifNeedUpdate = true
            currenciesTableView.reloadData()
        }
    }
    
    func update(byParameters: String) {

        let alert = networkManager.getDataFromNetwork(parametersQueries: byParameters, controller: self) { data in
            DispatchQueue.main.async {
                let dataHandlerCurrencies = DataHandler(data: data)
                self.listOfCurrencies.all = []
                for selectedCurrency in self.selectedCurrencyFromList.all {
                    let currencyInformation = dataHandlerCurrencies.get(inputInformation: selectedCurrency, settlementСurrency: .RUB)
                    self.listOfCurrencies.all.append(currencyInformation)
                }
                self.listOfCurrencies.settlementСurrency = self.settlementСurrency
                self.dismiss(animated: true)
            }
        }
        
        if let alert = alert {
            listOfCurrencies.all = selectedCurrencyFromList.all
            listOfCurrencies.settlementСurrency = self.settlementСurrency
            present(alert, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        listOfCurrencies.all.sort { symbol1, symbol2 in
            symbol1.currencySymbol < symbol2.currencySymbol
        }
        
        return listOfCurrencies.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyInformationTableViewCell", for: indexPath) as! CurrencyInformationTableViewCell
        cell.backgroundColor = .incomesViewControllerColor
        return cell.configure(from: listOfCurrencies.all[indexPath.row]) { [weak self] switchIsOn, object in
            if let strongSelf = self {
                
                if switchIsOn {
                    strongSelf.parametersQueries += object.currencySymbol + ","
                    strongSelf.selectedCurrencyFromList.all.append(object)
                } else {
                    strongSelf.parametersQueries = strongSelf.parametersQueries.replacingOccurrences(of: object.currencySymbol + ",", with: "")
                    if let index = strongSelf.selectedCurrencyFromList.all.firstIndex(where: { $0.currencySymbol == object.currencySymbol }) {
                        strongSelf.selectedCurrencyFromList.all.remove(at: index)
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UIPickerViewDataSource
extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ListSymbolsAndNamesCurrency.allCases.count
    }
}

//MARK: - UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        label.text = ListSymbolsAndNamesCurrency.allCases[row].getAssociatedValue()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow settlementСurrency: Int, inComponent component: Int) {

        if let currenciesTableView = currenciesTableView {
            
            var index: Int = 0
            listOfCurrencies.all.forEach { currency in
                if currency.currencySymbol == ListSymbolsAndNamesCurrency.allCases[settlementСurrency].rawValue {
                    if let listElement = listElement {
                        listOfCurrencies.all.append(listElement)
                    }
                    listElement = listOfCurrencies.all.remove(at: index)
                }
                index += 1
            }
            currenciesTableView.reloadData()
        }
        self.settlementСurrency = settlementСurrency
    }
}

//MARK: - CustomizeSettingsViewController
extension SettingsViewController {
    
    private func customizeLogoImageView() {
        
        let image = UIImage(named: "logo-open-exchange-rates-white")
        if let image = image {
            let scaledImage = image.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
            logoImageView = UIImageView(image: scaledImage)
        }

        if let logoImageView = logoImageView {
            logoImageView.contentMode = .scaleAspectFit
            
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(logoImageView)
            
            NSLayoutConstraint.activate([
                logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
                logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35.0),
                logoImageView.widthAnchor.constraint(equalToConstant: 200.0),
                logoImageView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        }
    }
    
    private func customizeUrlSourseLabel() {
        
        urlSourseLabel = UILabel()
        guard let logoImageView = logoImageView,
              let urlSourseLabel = urlSourseLabel else { return }
        urlSourseLabel.text = "https://openexchangerates.org"
        urlSourseLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        urlSourseLabel.sizeToFit()
        urlSourseLabel.textColor = .blue
        
        urlSourseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urlSourseLabel)

        NSLayoutConstraint.activate([
            urlSourseLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0.0),
            urlSourseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35.0)
        ])
    }
    
    private func customizeSettlementСurrencyLabel() {
        settlementСurrencyLabel = UILabel()
        guard let settlementСurrencyLabel = settlementСurrencyLabel else { return }
        settlementСurrencyLabel.text = "Валюта расчета"
        settlementСurrencyLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        settlementСurrencyLabel.sizeToFit()
        settlementСurrencyLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        
        settlementСurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settlementСurrencyLabel)

        NSLayoutConstraint.activate([
            settlementСurrencyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130.0),
            settlementСurrencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0)
        ])
    }
    
    private func customizeSettlementСurrencyPickerView() {
        settlementСurrencyPickerView = UIPickerView()
        guard let settlementСurrencyPickerView = settlementСurrencyPickerView else { return }
        settlementСurrencyPickerView.delegate = self
        settlementСurrencyPickerView.dataSource = self
        settlementСurrencyPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settlementСurrencyPickerView)

        NSLayoutConstraint.activate([
            settlementСurrencyPickerView.widthAnchor.constraint(equalToConstant: 150.0),
            settlementСurrencyPickerView.heightAnchor.constraint(equalToConstant: 50.0),
            settlementСurrencyPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 115.0),
            settlementСurrencyPickerView.leadingAnchor.constraint(equalTo: settlementСurrencyLabel!.trailingAnchor, constant: 2.0)
        ])
    }
    
    private func customizeListLabel() {
        listLabel = UILabel()
        guard let listLabel = listLabel else { return }
        listLabel.text = "Список валют"
        listLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        listLabel.sizeToFit()
        listLabel.textColor = .blue
        
        listLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listLabel)

        NSLayoutConstraint.activate([
            listLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 175.0),
            listLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0)
        ])
    }
    
    private func customizeUpdateDataButton() {
        
        updateDataButton = UIButton(type: .custom)
        guard let updateDataButton = updateDataButton,
              let listLabel = listLabel else { return }
        updateDataButton.backgroundColor = .blue
        updateDataButton.setTitle("Обновить курсы", for: .normal)
        updateDataButton.setTitleColor(.white, for: .normal)
        updateDataButton.setTitleColor(.lightGray, for: .selected)
        
        updateDataButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateDataButton)

        NSLayoutConstraint.activate([
            updateDataButton.widthAnchor.constraint(equalToConstant: 145.0),
            updateDataButton.heightAnchor.constraint(equalToConstant: 30.0),
            updateDataButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            updateDataButton.leadingAnchor.constraint(equalTo: listLabel.trailingAnchor, constant: 4.0)
        ])
        
        updateDataButton.addTarget(self, action: #selector(updateCurrencyList), for: .touchUpInside)
    }

    private func customizeTableView() {
        
        currenciesTableView = UITableView(frame: CGRect(x: 0.0,
                                                        y: 205.0,
                                                        width: view.bounds.width / 4.0 * 3.0,
                                                        height: view.frame.height / 3.0 * 1.95), style: .plain)
        
        if let currenciesTableView = currenciesTableView {
            currenciesTableView.dataSource = self
            currenciesTableView.delegate = self
            currenciesTableView.register(UINib(nibName: "CurrencyInformationTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "currencyInformationTableViewCell")
            currenciesTableView.backgroundColor = .incomesViewControllerColor
            currenciesTableView.separatorColor = .white
            view.addSubview(currenciesTableView)
        }
    }
    
    private func customizeResetListCurrenciesButton() {
        
        resetListCurrenciesButton = UIButton(type: .custom)
        guard let resetListCurrenciesButton = resetListCurrenciesButton,
              let currenciesTableView = currenciesTableView else { return }
        resetListCurrenciesButton.backgroundColor = .blue
        resetListCurrenciesButton.setTitle("Сбросить список", for: .normal)
        resetListCurrenciesButton.setTitleColor(.white, for: .normal)
        resetListCurrenciesButton.setTitleColor(.lightGray, for: .selected)
        
        resetListCurrenciesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetListCurrenciesButton)

        NSLayoutConstraint.activate([
            resetListCurrenciesButton.widthAnchor.constraint(equalToConstant: 170.0),
            resetListCurrenciesButton.heightAnchor.constraint(equalToConstant: 30.0),
            resetListCurrenciesButton.topAnchor.constraint(equalTo: currenciesTableView.bottomAnchor, constant: 20.0),
            resetListCurrenciesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0)
        ])
        
        resetListCurrenciesButton.addTarget(self, action: #selector(resetCurrencyList), for: .touchUpInside)
    }
}
