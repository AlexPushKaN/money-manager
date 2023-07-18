import UIKit

extension UIButton {
    
    enum State {
        case available
        case notAvailable
    }
    
    func setSelected(state: State) {
        switch state {
        case .available:
            self.isHighlighted = false
            self.isEnabled = true
        case .notAvailable:
            self.isHighlighted = true
            self.isEnabled = false
        }
    }
}
