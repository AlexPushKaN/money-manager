import UIKit

class CategoryExpensesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        detailLabel.font = UIFont.systemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(categoryExpenses: CategoryExpenses) -> UITableViewCell {

        titleLabel.text = categoryExpenses.name
        detailLabel.text = String(categoryExpenses.calculateCategory()) + " рублей"
        
        return self
    }
}
