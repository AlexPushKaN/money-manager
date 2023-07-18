import UIKit

class ToggleView: UIView {

    var numberOfItemsInTabBar: CGFloat = 0.0
    var textLabel: UILabel = UILabel()

    init(frame: CGRect, color: UIColor, borderColor: UIColor) {
        super.init(frame: frame)
        backgroundColor = color
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 5.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToggle(to item: Int, in tabBar: UITabBar, completionHandler: (() -> Void)? = nil) {
        
        let xCoordinate = tabBar.frame.width / numberOfItemsInTabBar
        let xFrameCentre = xCoordinate / 2.0
        addLabel(text: "")
        
        switch item {
        case 0:
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "Доходы")
            } completion: { _ in
                completionHandler?()
            }
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "График")
            } completion: { _ in
                completionHandler?()
            }
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "Расходы")
            } completion: { _ in
                completionHandler?()
            }
        default: break
        }
    }
    
    private func addLabel(text:String) {
        textLabel.text = text
        textLabel.textColor = .white
        textLabel.sizeToFit()
        textLabel.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        addSubview(textLabel)
    }
}
