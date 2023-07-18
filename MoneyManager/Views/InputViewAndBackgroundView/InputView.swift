import UIKit

class InputView: UIView {
    
    let spacingBetweenViews: CGFloat = 10.0
    
    enum InputViewComposition {
        case forIncomes
        case forExpenses
        case forCategoryExpenses
    }
    
    var inputViewComposition: InputViewComposition?
    
    lazy var inputNumberTextField: InputNumberTextField = {
        return InputNumberTextField(frame: CGRect(x: spacingBetweenViews, y: spacingBetweenViews, width: frame.width - spacingBetweenViews * 2, height: 50.0))
    }()
    
    lazy var inputTextTextField: InputTextTextField = {
        return InputTextTextField(frame: CGRect(x: spacingBetweenViews, y: spacingBetweenViews, width: frame.width - spacingBetweenViews * 2, height: 50.0))
    }()
    
    lazy var inputButton: InputButton = {
        return InputButton(frame: CGRect(x: spacingBetweenViews, y: inputNumberTextField.frame.maxY + spacingBetweenViews, width: frame.width - spacingBetweenViews * 2, height: 50.0))
    }()
    
    let screenSize: CGRect
    var keyboardFrame: CGRect?
    var digit: String = ""
    var text: String = ""
    
    var delegateForDigit: InputViewForDigitDelegate?
    var delegateForText: InputViewForTextDelegate?
    var delegateForAll: InputViewForAllDelegate?
    weak var delegateForRemove: RemoveFromSuperViewDelegate?
    
    override init(frame: CGRect) {
        self.screenSize = frame
        super.init(frame: frame)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(closeView(_:)))
        addGestureRecognizer(panGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        inputButton.delegate = self
        inputNumberTextField.delegate = self
        inputTextTextField.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardFrame = keyboardFrame
            self.frame.origin.y = screenSize.height - (self.frame.height + keyboardFrame.height)
        }
    }
    
    func configure(inputViewFor: Objects) {

        switch inputViewFor {
        case .incomes(_):
            addSubview(inputNumberTextField)
            addSubview(inputButton)
            inputViewComposition = .forIncomes
            backgroundColor = .tabBarItemsColor.withAlphaComponent(0.4)
            frame = CGRect(x: 0.0, y: screenSize.height, width: screenSize.width, height: inputNumberTextField.frame.height + inputButton.frame.height + spacingBetweenViews * 3)
        case .categoryExpenses(_):
            inputTextTextField.frame.origin.y = inputNumberTextField.frame.height + spacingBetweenViews * 2
            inputButton.frame.origin.y = inputNumberTextField.frame.height + inputTextTextField.frame.height + spacingBetweenViews * 3
            addSubview(inputNumberTextField)
            addSubview(inputTextTextField)
            addSubview(inputButton)
            inputViewComposition = .forCategoryExpenses
            backgroundColor = .lineExpense.withAlphaComponent(0.4)
            frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: inputNumberTextField.frame.height + inputTextTextField.frame.height + inputButton.frame.height + spacingBetweenViews * 4)
        case .expenses(_):
            addSubview(inputTextTextField)
            addSubview(inputButton)
            inputViewComposition = .forExpenses
            backgroundColor = .lineExpense.withAlphaComponent(0.4)
            frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: inputTextTextField.frame.height + inputButton.frame.height + spacingBetweenViews * 3)
        }
    }
    
    @objc
    private func closeView(_ gestureRecognizer: UIPanGestureRecognizer ){
        
        let translation = gestureRecognizer.translation(in: self)
        if gestureRecognizer.state == .changed {
            if translation.y > 0.0 {
                guard let keyboardFrame = keyboardFrame else { return }
                self.frame.origin.y = screenSize.height - self.frame.height - keyboardFrame.height + translation.y
            }
        } else if gestureRecognizer.state == .ended {
            if translation.y > 50.0 {
                delegateForRemove?.removeFromSuperView()
            }
            else {
                UIView.animate(withDuration: 0.5) { [weak self] in

                    guard let strongSelf = self, let keyboardFrame = strongSelf.keyboardFrame else { return }
                    strongSelf.frame.origin.y = strongSelf.screenSize.height - strongSelf.frame.height - keyboardFrame.height
                }
            }
        }
    }
}

//MARK: - TouchUpInsiteDelegate для передачи сообщения с информацией контроллеру
extension InputView: InputButtonDelegate {
    
    func clouseInputView() {
        if let delegateForAll = delegateForAll {
            delegateForAll.send(digit: Int(digit)!, text: text)
        } else if let delegateForIncome = delegateForDigit {
            delegateForIncome.send(digit: Int(digit)!)
        } else if let delegateForExpense = delegateForText {
            delegateForExpense.send(text: text)
        }
    }
}

//MARK: - UITextFieldDelegate
extension InputView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if !string.isEmpty {
            
            if inputNumberTextField.isEditing {
                digit.append(string)
                inputNumberTextField.text = digit + " P."
            } else if inputTextTextField.isEditing {
                return true
            }
            
        } else {

            if inputNumberTextField.isEditing {
                digit.removeLast()
                inputNumberTextField.text = digit.count > 0 ? digit + " Р." : ""
            } else if inputTextTextField.isEditing {
                return true
            }
        }

        return false
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let text = inputTextTextField.text {
            self.text = text
        }

        if let text = textField.text, !text.isEmpty && inputViewComposition == .forIncomes {
            inputButton.setSelected(state: .available)
        } else if let text = textField.text, !text.isEmpty && inputViewComposition == .forExpenses {
            inputButton.setSelected(state: .available)
        } else if let digit = inputNumberTextField.text,
                  let text = inputTextTextField.text,
                  !digit.isEmpty && !text.isEmpty && inputViewComposition == .forCategoryExpenses {
            inputButton.setSelected(state: .available)
        } else {
            inputButton.setSelected(state: .notAvailable)
        }

    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        if inputNumberTextField.isEditing {
            digit = ""
            inputNumberTextField.text = digit
        } else if inputTextTextField.isEditing {
            text = ""
            inputTextTextField.text = text
        }
        
        return true
    }
}
