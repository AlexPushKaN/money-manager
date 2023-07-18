import UIKit

class PresentationControllerForTickerSettings: UIPresentationController {
    
    var dimmingView: UIView? = nil
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let coordinateX: CGFloat = containerView.bounds.width - (containerView.bounds.width / 4 * 3)
        let coordinateY: CGFloat = 0.0
        let height: CGFloat = containerView.bounds.height
        let width: CGFloat = containerView.bounds.width / 4 * 3
        return CGRect(x: coordinateX,
                      y: coordinateY,
                      width: width,
                      height: height)
    }
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        containerView.addSubview(presentedView)
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.layer.cornerRadius = frameOfPresentedViewInContainerView.minX / 2
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        dimmingView = UIView(frame: containerView.bounds)
        
        if let dimmingView = dimmingView {
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            containerView.insertSubview(dimmingView, at: 0)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        if let dimmingView = dimmingView, let presentedView = presentedView {
            dimmingView.addGestureRecognizer(tapGesture)
            presentedView.addGestureRecognizer(swipeGesture)
        }
    }

    @objc private func handleTapGesture() {
        closingActions()
    }
    
    @objc private func handleSwipeGesture() {
        closingActions()
    }
    
    private func closingActions() {
        
        if let presentedController = presentedViewController as? SettingsViewController {
            
            presentedController.listOfCurrencies.all = []
            if presentedController.selectedCurrencyFromList.all.count > 0 {
                let alert = Alerts.show(alert: .updateData, title: "Получить курс валют", message: "Хотите ли Вы получить актуальный курс для выбранных валют?") { [weak self] ifNeedUpdate in
                    if ifNeedUpdate {
                        presentedController.ifNeedUpdate = ifNeedUpdate
                        presentedController.update(byParameters: presentedController.parametersQueries)
                    } else {
                        presentedController.ifNeedUpdate = ifNeedUpdate
                        presentedController.listOfCurrencies.all = presentedController.selectedCurrencyFromList.all
                        if let strongSelf = self {
                            strongSelf.presentingViewController.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                self.presentedViewController.present(alert, animated: true)
            } else {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

class CustomPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let finalFrame = transitionContext.finalFrame(for: toController)
        let initialFrame = CGRect(x: finalFrame.maxX, y: finalFrame.minY, width: finalFrame.width, height: finalFrame.height)
        
        toController.view.frame = initialFrame
        containerView.addSubview(toController.view)
        
        UIView.animate(withDuration: duration, animations: {
            toController.view.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class CustomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval = 0.3

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let finalFrame = transitionContext.finalFrame(for: fromController)

        UIView.animate(withDuration: duration, animations: {
            fromController.view.frame = CGRect(x: finalFrame.maxX, y: finalFrame.minY, width: finalFrame.width, height: finalFrame.height)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
