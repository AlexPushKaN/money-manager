import UIKit

class IncomeTableViewCell: UITableViewCell {
    
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
    
    func configure(value: Int, date: Date) -> UITableViewCell {
        
        let title = String(value) + " рублей"
        let detail = DateToString(date: date).convertToStringFormateThtree()
        
        titleLabel.text = title
        detailLabel.text = detail
        
        return self
    }
}
