import UIKit

class CustomLaunchScreenViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    
    var isRegistrationComplete: Bool = false
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.loadUser() {
            self.user = user
            isRegistrationComplete = true
        }
        
        animateLabels()
    }
    
    private func animateLabels() {

        moneyLabel.frame = CGRect(x: view.center.x - moneyLabel.frame.width / 2, y: 0.0, width: moneyLabel.frame.width, height: moneyLabel.frame.height)
        managerLabel.frame = CGRect(x: -managerLabel.frame.width, y: view.center.y - managerLabel.frame.height / 2, width: managerLabel.frame.width, height: managerLabel.frame.height)
        
        let endStateForMoneyLabel = view.center.y - moneyLabel.bounds.height - 20.0
        let endStateForManagerLabel = view.center.x
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0) {
            self.moneyLabel.frame.origin.y = endStateForMoneyLabel
        } completion: { _ in
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0) {
                self.managerLabel.frame.origin.x = endStateForManagerLabel
            } completion: { _ in
                if self.isRegistrationComplete {
                    self.performSegue(withIdentifier: "CustomLaunchScreenViewControllerToAuthorizationViewController", sender: self.user)
                } else {
                    self.performSegue(withIdentifier: "CustomLaunchScreenViewControllerToRegistrationUserViewController", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AuthorizationViewController, segue.identifier == "CustomLaunchScreenViewControllerToAuthorizationViewController" {
            controller.user = self.user
        }
    }
}
