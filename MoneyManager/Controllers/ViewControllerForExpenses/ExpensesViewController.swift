import UIKit

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var expensesStackView: UIStackView!
    @IBOutlet weak var categoriesExpensesTableView: UITableView!
    @IBOutlet weak var categoriesExpensesAddButton: UIButton!
    
    var expenses: Expenses = Expenses(allCategoriesExpenses: [])
    let coreDataManager = CoreDataManager.shared
    var totalCategoryAmount: Int = 0 {
        didSet{
            (expensesStackView.viewWithTag(1) as! UILabel).text = String(totalCategoryAmount) + " рублей"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeController()
        categoriesExpensesTableView.dataSource = self
        categoriesExpensesTableView.delegate = self
        
        guard let expensesEntity = try? ExpensesEntity.findOrCreate(context: coreDataManager.context),
              let categoriesExpensesEntity = expensesEntity.categoriesExpenses else { return }
        
        for categoryExpensesEntity in categoriesExpensesEntity {
            let categoryExpensesEntity = categoryExpensesEntity as! CategoryExpensesEntity
            guard let id = categoryExpensesEntity.id,
                  let name = categoryExpensesEntity.name else { return }
            var allExpense: [Expense] = []
            if let dataSet = categoryExpensesEntity.expense {
                for element in dataSet {
                    if let expenseEntity = element as? ExpenseEntity {
                        guard let id = expenseEntity.id,
                              let date = expenseEntity.date,
                              let name = expenseEntity.name else { return }
                        let expense = Expense(id: id, value: Int(expenseEntity.value), date: date, name: name)
                        allExpense.append(expense)
                    }
                }
            }
            
            let categoryExpenses = CategoryExpenses(id: id, name: name, allExpense: allExpense)
            self.expenses.allCategoriesExpenses.append(categoryExpenses)
            
        }
        
        totalCategoryAmount = expenses.allCategoriesExpenses.reduce(0, { $0 + $1.calculateCategory() })
    }
    
    private func customizeController() {
        view.backgroundColor = .expensesViewControllerColor
        expensesStackView.layer.cornerRadius = 10.0
        expensesStackView.layer.borderWidth = 5.0
        expensesStackView.layer.borderColor = #colorLiteral(red: 0.8872601986, green: 0.4371592999, blue: 0.4239928722, alpha: 1)
        categoriesExpensesTableView.separatorColor = .white
        categoriesExpensesTableView.layer.cornerRadius = 10.0
        categoriesExpensesTableView.layer.borderWidth = 5.0
        categoriesExpensesTableView.layer.borderColor = #colorLiteral(red: 0.8872601986, green: 0.4371592999, blue: 0.4239928722, alpha: 1)
        categoriesExpensesAddButton.layer.cornerRadius = categoriesExpensesAddButton.bounds.height / 2
        categoriesExpensesAddButton.layer.borderWidth = 5.0
        categoriesExpensesAddButton.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }
    
    @IBAction func didPressCategoriesExpensesAddButton(_ sender: UIButton) {
        let inputView = InputView(frame: view.bounds)
        inputView.configure(inputViewFor: .expenses(expenses))
        let backgroundView = BackgroundView(frame: view.bounds)
        backgroundView.animate()
        inputView.delegateForText = self
        inputView.delegateForRemove = self
        backgroundView.delegateForRemove = self
        view.addSubview(backgroundView)
        view.addSubview(inputView)
        inputView.inputTextTextField.becomeFirstResponder()
    }
}

//MARK: - UITableViewDataSource
extension ExpensesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCategoryAmount = expenses.allCategoriesExpenses.reduce(0, { $0 + $1.calculateCategory() })
        return expenses.allCategoriesExpenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryExpensesCell", for: indexPath) as! CategoryExpensesTableViewCell
        return cell.configure(categoryExpenses: expenses.allCategoriesExpenses[indexPath.row])
    }
}

//MARK: - UITableViewDelegate
extension ExpensesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! CategoryExpensesTableViewCell
        header.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        header.detailLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryExpensesViewController = storyboard.instantiateViewController(withIdentifier: "CategoryExpensesViewController") as! CategoryExpensesViewController
        categoryExpensesViewController.categoryExpenses = expenses.allCategoriesExpenses[indexPath.row]
        categoryExpensesViewController.completion = {
            self.categoriesExpensesTableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(categoryExpensesViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let categoryExpenses = expenses.allCategoriesExpenses.remove(at: indexPath.row)
            coreDataManager.delete(entity: .expenses(expenses), id: categoryExpenses.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - InputViewDelegate and remove InputView and BackgroundView from IncomesViewController
extension ExpensesViewController: InputViewForTextDelegate {

    func send(text name: String) {
        
        removeFromSuperView()
        
        if !name.isEmpty {
            let categoryExpenses = CategoryExpenses(id: UUID(), name: name, allExpense: [])
            expenses.allCategoriesExpenses.append(categoryExpenses)
            categoriesExpensesTableView.reloadData()
            coreDataManager.add(entity: .expenses(expenses))
        }
    }
}

//MARK: - RemoveFromSuperViewDelegate
extension ExpensesViewController: RemoveFromSuperViewDelegate {
    func removeFromSuperView() {
        for view in view.subviews {
            if view is InputView || view is BackgroundView {
                view.removeFromSuperview()
            }
        }
    }
}
