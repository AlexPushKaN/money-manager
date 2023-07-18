import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textEntryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(expense: Expense) -> UITableViewCell {

        textEntryLabel.text = expense.name
        dateLabel.text = DateToString(date: expense.date).convertToStringFormateThtree()
        expenseLabel.text = String(expense.value) + " рублей"
        return self
    }
}
