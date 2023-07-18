import UIKit

class InputNumberTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // - кастомизация поля ввода
        backgroundColor = .white
        textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        borderStyle = .roundedRect
        clearButtonMode = .always
        keyboardType = .numberPad
        placeholder = "Введите сумму"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1).withAlphaComponent(0.5)
        ]
        
        if let placeholder = self.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            self.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
