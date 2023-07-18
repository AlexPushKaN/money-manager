import UIKit

class IncomesViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var incomeAddButton: UIButton!
    
    let tickerHeight: CGFloat = 50.0
    let constraintBottom: CGFloat = -8.0
    let settingsTickerButtonWidth: CGFloat = 50.0
    
    lazy var tickerView = {
        return TickerView(frame: CGRect(x: headerView.frame.minX,
                                        y: constraintBottom,
                                        width: 0.0,
                                        height: tickerHeight))
    }()
    
    lazy var settingsTickerButton = {
        let button = UIButton(frame: CGRect(x: headerView.frame.minX,
                                            y: constraintBottom,
                                            width: settingsTickerButtonWidth,
                                            height: tickerHeight))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressSettingsTickerButton))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    var balanceAccount: Int = 0 {
        didSet {
            incomeTableView.reloadData()
            UIView.transition(with: balanceLabel,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.balanceLabel.text = String(self.balanceAccount) + " рублей"
            }
        }
    }
    
    var incomes: Incomes = Incomes(allIncome: [])
    let coreDataManager = CoreDataManager.shared
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeController()
        
        incomeTableView.dataSource = self
        incomeTableView.delegate = self
        
        guard let incomesEntity = try? IncomesEntity.findOrCreate(context: coreDataManager.context),
              let incomesEntity = incomesEntity.income else { return }
        
        for incomeEntity in incomesEntity {
            let incomeEntity = incomeEntity as! IncomeEntity
            let income = Income(id: incomeEntity.id!, value: Int(incomeEntity.value), date: incomeEntity.date!)
            incomes.allIncome.append(income)
        }
        
        balanceAccount = incomes.calculateAccountAmount()
        balanceLabel.text = String(balanceAccount) + " рублей"

        tickerView.create(labelsForTicker: ListOfCurrencies.loadInformation())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startTickerAnimate(andSettingsTickerButton: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tickerView.frame = CGRect(x: self.headerView.frame.minX,
                                  y: constraintBottom,
                                  width: 0.0,
                                  height: self.tickerHeight)
        settingsTickerButton.frame.origin.x = headerView.frame.minX
    }
    
    func startTickerAnimate(andSettingsTickerButton: Bool) {
        if andSettingsTickerButton {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear]) {
                self.settingsTickerButton.frame.origin.x = self.headerView.frame.maxX - self.settingsTickerButton.frame.width
                self.tickerView.frame = CGRect(x: self.headerView.frame.minX,
                                               y: self.constraintBottom,
                                               width: self.headerView.frame.width - self.settingsTickerButton.frame.width,
                                               height: self.tickerHeight)
            } completion: { [weak self] _ in
                if let strongSelf = self {
                    strongSelf.tickerView.animateTicker()
                }
            }
        } else {
            tickerView.animateTicker()
        }
    }
    
    private func customizeController() {
        
        view.backgroundColor = .incomesViewControllerColor
        
        let bottomBorderLayer = CALayer()
        let borderHeight = 5.0
        bottomBorderLayer.frame = CGRect(x: 0.0,
                                         y: tickerView.frame.height - borderHeight,
                                         width: headerView.frame.width,
                                         height: borderHeight)
        bottomBorderLayer.backgroundColor = #colorLiteral(red: 0.001153743593, green: 0.5894083381, blue: 0.9987381101, alpha: 1)
        tickerView.layer.addSublayer(bottomBorderLayer)
        
        let path = UIBezierPath(roundedRect: settingsTickerButton.bounds,
                                byRoundingCorners: [.topRight,.bottomRight],
                                cornerRadii: CGSize(width: 10.0, height: 10.0))
        let subLayer = CAShapeLayer()
        subLayer.path = path.cgPath
        subLayer.fillColor = #colorLiteral(red: 0, green: 0.5854616165, blue: 0.9947683215, alpha: 1)
        settingsTickerButton.layer.addSublayer(subLayer)
        settingsTickerButton.contentVerticalAlignment = .center
        let image = UIImage(systemName: "gear")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 5.0,
                                 y: 5.0,
                                 width: settingsTickerButton.bounds.height - 10.0,
                                 height: settingsTickerButton.bounds.height - 10.0)
        imageView.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        settingsTickerButton.addSubview(imageView)
        
        tickerView.translatesAutoresizingMaskIntoConstraints = false
        settingsTickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tickerView)
        view.addSubview(settingsTickerButton)
        
        NSLayoutConstraint.activate([

            tickerView.bottomAnchor.constraint(equalTo: headerView.topAnchor, constant: constraintBottom),
            tickerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            tickerView.trailingAnchor.constraint(equalTo: settingsTickerButton.leadingAnchor),
            tickerView.heightAnchor.constraint(equalToConstant: tickerHeight),

            settingsTickerButton.bottomAnchor.constraint(equalTo: headerView.topAnchor, constant: constraintBottom),
            settingsTickerButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            settingsTickerButton.widthAnchor.constraint(equalToConstant: settingsTickerButtonWidth),
            settingsTickerButton.heightAnchor.constraint(equalToConstant: tickerHeight)
            
        ])
        
        headerView.layer.cornerRadius = 10.0
        headerView.layer.borderWidth = 5.0
        headerView.layer.borderColor = UIColor.incomeBorderColor.cgColor

        incomeTableView.separatorColor = .white
        incomeTableView.layer.cornerRadius = 10.0
        incomeTableView.layer.borderWidth = 5.0
        incomeTableView.layer.borderColor = UIColor.incomeBorderColor.cgColor
        incomeAddButton.layer.cornerRadius = incomeAddButton.bounds.height / 2
        incomeAddButton.layer.borderWidth = 5.0
        incomeAddButton.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }
    
    @IBAction func didPressSettingsTickerButton() {

        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .custom
        settingsViewController.transitioningDelegate = self
        present(settingsViewController, animated: true, completion: nil)
    }
    
    @IBAction func didPressIncomeAddButton(_ sender: UIButton) {
        
        let inputView = InputView(frame: view.bounds)
        inputView.configure(inputViewFor: .incomes(incomes))
        let backgroundView = BackgroundView(frame: view.bounds)
        backgroundView.animate()
        inputView.delegateForDigit = self
        inputView.delegateForRemove = self
        backgroundView.delegateForRemove = self
        view.addSubview(backgroundView)
        view.addSubview(inputView)
        inputView.inputNumberTextField.becomeFirstResponder()
    }
}

//MARK: - UITableViewDataSource
extension IncomesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.allIncome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        return cell.configure(value: incomes.allIncome[indexPath.row].value, date: incomes.allIncome[indexPath.row].date)
    }
}

//MARK: - UITableViewDelegate
extension IncomesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! IncomeTableViewCell
        header.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        header.detailLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let income = incomes.allIncome.remove(at: indexPath.row)
            coreDataManager.delete(entity: .incomes(incomes), id: income.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - InputViewDelegate and remove InputView and BackgroundView from IncomesViewController
extension IncomesViewController: InputViewForDigitDelegate {
    
    func send(digit: Int)  {
        
        removeFromSuperView()
        
        if digit > 0 {
            let income = Income(id: UUID(), value: digit, date: Date())
            incomes.allIncome.append(income)
            balanceAccount += income.value
            coreDataManager.add(entity: .incomes(incomes))
        }
    }
}

//MARK: - RemoveFromSuperViewDelegate
extension IncomesViewController: RemoveFromSuperViewDelegate {
    func removeFromSuperView() {
        for view in view.subviews {
            if view is InputView || view is BackgroundView {
                view.removeFromSuperview()
            }
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension IncomesViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationControllerForTickerSettings(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimator()
    }
}


