import UIKit

class CurrencyInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var object: CurrencyInformation?
    var completion: ((Bool, CurrencyInformation)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleSwitch.onTintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(from currencyData: CurrencyInformation, completionHandler: @escaping (_ switchIsOn: Bool, _ object: CurrencyInformation)->()) -> UITableViewCell {
        
        currencySymbolLabel.text = currencyData.currencySymbol
        currencyNameLabel.text = currencyData.currencyName
        toggleSwitch.isOn = currencyData.statusInListOfCurrencies
        object = currencyData
        self.completion = completionHandler
        return self
    }
    
    @IBAction func selectToggle(_ sender: UISwitch) {
        if let object = object {
            object.statusInListOfCurrencies = sender.isOn
            completion?(sender.isOn, object)
        }
    }
}
