import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var passwordEntryTextField: CustomeTextField!
    @IBOutlet weak var failedPasswordLabel: UILabel!
    @IBOutlet weak var appleImageView: UIImageView!
    
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pieceOfAppleView = PieceOfAppleView(frame: CGRect(x: 94.0, y: 45.0, width: 20.0, height: 35.0))
        appleImageView.addSubview(pieceOfAppleView)
        failedPasswordLabel.isHidden = true
        passwordEntryTextField.delegate = self
        
        if let user = self.user {
            nameUserLabel.text = "Привет, " + user.name + "!"
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func closeKeyboard(){
        
        passwordEntryTextField.resignFirstResponder()
    }
    
    @IBAction func registrationAgain() {
        
        let alert = Alerts.show(alert: .registrationAgain, title: "В случае перерегистрации, Ваши данные будут безвозвратно удалены!", message: "Вы уверенны, что хотите продолжить регистрацию?", completion: {_ in
            self.performSegue(withIdentifier: "AuthorizationViewControllerToRegistrationUserViewController", sender: nil)
        })
        present(alert, animated: true)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let user = self.user else { return false }
        
        if passwordEntryTextField.text == user.password {
            
            passwordEntryTextField.resignFirstResponder()
            failedPasswordLabel.isHidden = true
            
            if let view = self.appleImageView.subviews.first {
                UIView.animate(withDuration: 0.5) {
                    view.alpha = 0.0
                } completion: { _ in
                    view.removeFromSuperview()
                    self.performSegue(withIdentifier: "AuthorizationViewControllerToMoneyManagerTabBarController", sender: nil)
                }
            }
        } else {

            failedPasswordLabel.isHidden = false

            UIView.animate(withDuration: 2.0) {
                self.failedPasswordLabel.alpha = 0.0
            } completion: { _ in
                self.failedPasswordLabel.isHidden = true
                self.failedPasswordLabel.alpha = 1.0
            }
        }
        return true
    }
}
