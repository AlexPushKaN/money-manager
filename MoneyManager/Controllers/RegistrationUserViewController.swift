import UIKit

class RegistrationUserViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomeTextField!
    @IBOutlet weak var passwordTextField: CustomeTextField!
    @IBOutlet weak var appleImageView: UIImageView!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pieceOfAppleView = PieceOfAppleView(frame: CGRect(x: 94.0, y: 45.0, width: 20.0, height: 35.0))
        appleImageView.addSubview(pieceOfAppleView)
        
        nameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func closeKeyboard(){
        
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func completeRegistration() {
        
        if nameTextField.text!.isEmpty {
            present(Alerts.show(alert: .inputName, title: "Введите имя", message: "Для продолжения регистрации введите имя", completion: nil), animated: true)
        } else if passwordTextField.text!.isEmpty {
            present(Alerts.show(alert: .inputPassword, title: "Введите пароль", message: "Для продолжения регистрации введите пароль", completion: nil), animated: true)
        }
        
        if let name = nameTextField.text,
           let password = passwordTextField.text,
           name.count > 0,
           password.count > 0 {
            let user = User(name: name, password: password)
            User.save(user: user)
            
            passwordTextField.resignFirstResponder()
            nameTextField.resignFirstResponder()
            
            if let view = self.appleImageView.subviews.first {
                UIView.animate(withDuration: 0.5) {
                    view.alpha = 0.0
                } completion: { _ in
                    view.removeFromSuperview()
                    self.performSegue(withIdentifier: "RegistrationUserViewControllerToMoneyManagerTabBarController", sender: nil)
                }
            }
        }
    }
    
    @IBAction func backInAuthorizationViewController() {
        dismiss(animated: true)
    }
}

extension RegistrationUserViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let nameText = nameTextField.text,
              let passwordText = passwordTextField.text else { return false }
        
        if textField == nameTextField && passwordText.isEmpty {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField && nameText.isEmpty {
            nameTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            nameTextField.resignFirstResponder()
        }
        
        return true
    }
}
