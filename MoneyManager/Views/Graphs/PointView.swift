import UIKit

class PointView: UIView {

    let value: Int
    let date: Date
    var assigment: PointAssignment?
    weak var presentAlertDelegate: PresentAlertDelegate?
    weak var presentCategoryExpensesViewControllerDelegate: PresentCategoryExpensesViewControllerDelegate?
    
    init(frame: CGRect, object: UniversalProtocol) {
        self.value = object.value
        self.date = object.date
        if object is Income {
            self.assigment = .forPointIncome(object as! Income)
        } else if object is CategoryExpenses {
            self.assigment = .forPointCategoryExpenses(object as! CategoryExpenses)
        } else if object is Expense {
            self.assigment = .forPointExpense(object as! Expense)
        }
        super.init(frame: frame)
        addTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorPoint(backgroundColor: UIColor, borderColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = bounds.height / 2.0
        layer.borderWidth = 2.0
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }

    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let assigment = assigment else { return }
        let alert = Alerts.create(forAssigment: assigment) { object in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryExpensesViewController = storyboard.instantiateViewController(withIdentifier: "CategoryExpensesViewController") as! CategoryExpensesViewController
            categoryExpensesViewController.categoryExpenses = object as? CategoryExpenses
            self.presentCategoryExpensesViewControllerDelegate?.present(viewController: categoryExpensesViewController)
        }
        presentAlertDelegate?.present(alert: alert)
    }
}
