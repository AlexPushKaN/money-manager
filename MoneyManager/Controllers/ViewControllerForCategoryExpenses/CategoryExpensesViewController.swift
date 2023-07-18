import UIKit

class CategoryExpensesViewController: UIViewController {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var graphShowButton: UIButton!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var expenseAddButton: UIButton!
    
    weak var categoryExpenses: CategoryExpenses?
    let coreDataManager = CoreDataManager.shared
    var completion: (() -> Void)? = nil
    var totalExpenses: Int = 0 {
        didSet {
            UIView.transition(with: totalExpensesLabel, duration: 0.2, options: .transitionCrossDissolve) {
                self.totalExpensesLabel.text = String(self.totalExpenses) + " рублей"
            } completion: { _ in
                self.expensesTableView.reloadData()
                self.completion?()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalExpenses = categoryExpenses?.calculateCategory() ?? 0
        graphShowButton.backgroundColor = #colorLiteral(red: 0.9976201653, green: 0.4938954115, blue: 0.4776279926, alpha: 1)
        if let categoryExpenses = categoryExpenses, categoryExpenses.allExpense.count > 0 {
            graphShowButton.setSelected(state: .available)
            graphShowButton.backgroundColor = #colorLiteral(red: 0.01768360101, green: 0.1995446384, blue: 1, alpha: 1)
        }
        expensesTableView.dataSource = self
        expensesTableView.delegate = self
        expensesTableView.register(UINib(nibName: "ExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "expenseCell")
        customizeController()
    }
    
    private func customizeController() {
        view.backgroundColor = .expensesViewControllerColor
        headerStackView.layer.cornerRadius = 10.0
        headerStackView.layer.borderWidth = 5.0
        headerStackView.layer.borderColor = #colorLiteral(red: 0.8889635205, green: 0.4380031228, blue: 0.4246240556, alpha: 1)
        expensesTableView.separatorColor = .white
        expensesTableView.layer.cornerRadius = 10.0
        expensesTableView.layer.borderWidth = 5.0
        expensesTableView.layer.borderColor = #colorLiteral(red: 0.8889635205, green: 0.4380031228, blue: 0.4246240556, alpha: 1)
        expenseAddButton.layer.cornerRadius = expenseAddButton.bounds.height / 2
        expenseAddButton.layer.borderWidth = 5.0
        expenseAddButton.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }
    
    @IBAction func didPressExpenseAddButton(_ sender: UIButton) {
        let inputView = InputView(frame: view.bounds)
        guard let categoryExpenses = categoryExpenses else { return }
        inputView.configure(inputViewFor: .categoryExpenses(categoryExpenses))
        let backgroundView = BackgroundView(frame: view.bounds)
        backgroundView.animate()
        inputView.delegateForAll = self
        inputView.delegateForRemove = self
        backgroundView.delegateForRemove = self
        view.addSubview(backgroundView)
        view.addSubview(inputView)
        inputView.inputTextTextField.becomeFirstResponder()
        inputView.inputNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func didPressGraphShowButton(_ sender: UIButton) {
        if let categoryExpenses = categoryExpenses, categoryExpenses.allExpense.count > 0 {
            performSegue(withIdentifier: "categoryExpensesViewControllerToGraphForExpenseViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let graphForExpenseViewController = segue.destination as? GraphForExpenseViewController {
            graphForExpenseViewController.categoryExpenses = categoryExpenses
        }
    }
}

//MARK: - UITableViewDataSource
extension CategoryExpensesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categoryExpenses = categoryExpenses else { return 0 }
        return categoryExpenses.allExpense.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseTableViewCell
        guard let categoryExpenses = categoryExpenses else { return cell }
        return cell.configure(expense: categoryExpenses.allExpense[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Заголовок таблицы"
        }
        return nil
    }
}

//MARK: - UITableViewDelegate
extension CategoryExpensesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let categoryExpenses = categoryExpenses else { return }
            let expense = categoryExpenses.allExpense.remove(at: indexPath.row)
            graphShowButton.setSelected(state: .notAvailable)
            graphShowButton.backgroundColor = #colorLiteral(red: 0.8933615088, green: 0.4376265109, blue: 0.4244416356, alpha: 1)
            coreDataManager.delete(entity: .categoryExpenses(categoryExpenses), id: expense.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            totalExpenses = categoryExpenses.calculateCategory()
        }
    }
}

//MARK: - InputViewForIncomeDelegate, InputViewForExpenseDelegate
extension CategoryExpensesViewController: InputViewForAllDelegate {
    
    func send(digit: Int, text name: String) {
        
        removeFromSuperView()
        
        if !digit.description.isEmpty && !name.isEmpty {
            let expense = Expense(id: UUID(), value: digit, date: Date(), name: name)
            guard let categoryExpenses = categoryExpenses else { return }
            categoryExpenses.allExpense.append(expense)
            totalExpenses = categoryExpenses.calculateCategory()
            graphShowButton.setSelected(state: .available)
            graphShowButton.backgroundColor = #colorLiteral(red: 0.01768360101, green: 0.1995446384, blue: 1, alpha: 1)
            coreDataManager.add(entity: .categoryExpenses(categoryExpenses))
        }
    }
}

//MARK: - RemoveFromSuperViewDelegate
extension CategoryExpensesViewController: RemoveFromSuperViewDelegate {
    
    func removeFromSuperView() {
        for view in view.subviews {
            if view is InputView || view is BackgroundView {
                view.removeFromSuperview()
            }
        }
    }
}
