//
//  IncomeTableViewCell.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 31.05.2023.
//

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

        // Configure the view for the selected state
    }
    
    func configure(value:Int, date:Date) -> UITableViewCell {
        
        let title = String(value) + " рублей"
        let detail = DateToString(date: date).convertToStringFormateOne()
        
        titleLabel.text = title
        detailLabel.text = detail
        
        return self
    }

}
