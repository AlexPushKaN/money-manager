import UIKit
import CoreData

class MoneyManagerTabBarController: UITabBarController {
    
    let coreDataManager = CoreDataManager.shared
    var incomes: Incomes = Incomes(allIncome: [])
    var expenses: Expenses = Expenses(allCategoriesExpenses: [])
    
    lazy var numberOfItemsInTabBar: CGFloat = {
        guard let controllers = viewControllers else { return 0 }
        return CGFloat(controllers.count)
    }()
    var toggle: ToggleView = ToggleView(frame: CGRect(),
                                        color: .tabBarItemsColor,
                                        borderColor: .blue)
    var shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureBaseNavigationTabBarController(for: viewControllers!)
        configureToggleView()
        configureToggleLabelSimulation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateToggleLabelSimulation()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == viewControllers?[2].tabBarItem.tag ||
            item.tag == viewControllers?[0].tabBarItem.tag {
            toggle.moveToggle(to: item.tag, in: tabBar)
        }
    }
    
    private func configureBaseNavigationTabBarController(for controllers: [UIViewController]) {
        
        var afterAddItemArrayControllers:[UIViewController] = []
        
        for (index, controller) in controllers.enumerated() {
            let item = UITabBarItem(title: nil, image: nil, tag: index)
            controller.tabBarItem = item
            afterAddItemArrayControllers.append(controller)
        }
        
        viewControllers = afterAddItemArrayControllers
    }
    
    private func configureToggleView() {
        
        let toggleWidth: CGFloat = tabBar.frame.width / numberOfItemsInTabBar - 20.0
        let toggleHeight: CGFloat = 50.0
        let toggleCoordinateX: CGFloat = tabBar.frame.width / numberOfItemsInTabBar / 2 - toggleWidth / 2
        let toggleCoordinateY: CGFloat = 0.0
        
        toggle.numberOfItemsInTabBar = numberOfItemsInTabBar
        toggle.frame = CGRect(x: toggleCoordinateX, y: toggleCoordinateY, width: toggleWidth, height: toggleHeight)
        toggle.layer.cornerRadius = toggle.frame.height / 2
        toggle.moveToggle(to: 0, in: tabBar)
        tabBar.addSubview(toggle)
    }
    
    private func configureToggleLabelSimulation() {
        
        let coordinateCentreFrameTabBarX = tabBar.frame.width / numberOfItemsInTabBar + tabBar.frame.width / numberOfItemsInTabBar / 2
        let frame = CGRect(x: coordinateCentreFrameTabBarX - toggle.bounds.width / 2,
                           y: 0.0,
                           width: toggle.bounds.width,
                           height: toggle.bounds.height)
        
        shapeLayer.fillColor = UIColor.tabBarItemsColor.withAlphaComponent(0.2).cgColor
        shapeLayer.strokeColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        shapeLayer.lineWidth = 5.0
        
        let toggleLabelSimulation = UIBezierPath(roundedRect: frame, cornerRadius: frame.height / 2)
        shapeLayer.path = toggleLabelSimulation.cgPath
        
        let textLayer = CATextLayer()
        textLayer.string = "График"
        textLayer.fontSize = 17.0
        textLayer.foregroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        textLayer.alignmentMode = .center
        textLayer.frame = frame
        textLayer.frame.origin.y = 12.5
        
        shapeLayer.addSublayer(textLayer)
        tabBar.layer.addSublayer(shapeLayer)
    }
    
    private func animateToggleLabelSimulation() {
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [
            NSValue(cgPoint: shapeLayer.position),
            NSValue(cgPoint: CGPoint(x: shapeLayer.position.x - 2.5, y: shapeLayer.position.y)),
            NSValue(cgPoint: CGPoint(x: shapeLayer.position.x + 2.5, y: shapeLayer.position.y)),
            NSValue(cgPoint: shapeLayer.position)
        ]
        positionAnimation.keyTimes = [0, 0.25, 0.75, 1]
        positionAnimation.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        ]
        positionAnimation.duration = 0.5
        positionAnimation.repeatCount = .infinity
        
        shapeLayer.add(positionAnimation, forKey: "positionAnimation")
    }
}

//MARK: - UITabBarControllerDelegate
extension MoneyManagerTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == viewControllers?[1].tabBarItem.tag {
            
            (incomes, expenses) = CoreDataManager.uploadDataFromCoreData()

            if incomes.allIncome.count > 0 || expenses.allCategoriesExpenses.reduce(into: 0, { partialResult, category in
                partialResult += category.allExpense.count }) > 0 {
                
                toggle.moveToggle(to: viewController.tabBarItem.tag, in: tabBar) {
                    
                    let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
                    fadeOutAnimation.fromValue = 1.0
                    fadeOutAnimation.toValue = 0.0
                    fadeOutAnimation.duration = 0.5
                    fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                    self.shapeLayer.add(fadeOutAnimation, forKey: "fadeOutAnimation")
                    DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutAnimation.duration) {
                        self.shapeLayer.removeFromSuperlayer()
                    }
                }
                
                return true
                
            } else {
                
                let alert = Alerts.show(alert: .isNoDataForGraph, title: "Нет данных", message: "Для построения графика нужны данные: укажите Ваши доходы или расходы")
                self.present(alert, animated: true)
                
                return false
            }
        }
        return true
    }
}
