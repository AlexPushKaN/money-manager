import UIKit

class BackgroundView: UIView {
    
    weak var delegateForRemove: RemoveFromSuperViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @objc
    private func closeView(){
    
        UIView.animate(withDuration: 0.15, delay: 0.0) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        } completion: { _ in
            self.delegateForRemove?.removeFromSuperView()
        }
    }
}
