import UIKit

class CustomeTextField: UITextField {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.cornerRadius = 5.0
        layer.borderWidth = 2.0
        backgroundColor = .white
        layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1).withAlphaComponent(0.5).cgColor
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1).withAlphaComponent(0.5)
        ]
        
        if let placeholder = self.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            self.attributedPlaceholder = attributedPlaceholder
        }
    }
}
