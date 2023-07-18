import UIKit

protocol InputButtonDelegate {
    func clouseInputView()
}

class InputButton: UIButton {
    
    var delegate: InputButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // - кастомизация кнопки
        backgroundColor = .tabBarItemsColor
        setTitle("Добавить запись", for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        layer.borderWidth = 5.0
        layer.borderColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        layer.cornerRadius = frame.height / 2.0
        setSelected(state: .notAvailable)
        
        // - добавление action
        addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapButton() {
        delegate?.clouseInputView()
    }
}
