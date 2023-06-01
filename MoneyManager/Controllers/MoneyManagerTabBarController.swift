//
//  TabBarController.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 29.05.2023.
//

import UIKit

class MoneyManagerTabBarController: UITabBarController {
    
    lazy var numberOfItemsInTabBar:CGFloat = {
        guard let controllers = viewControllers else { return 0}
        return CGFloat(controllers.count)
    }()
    
    var toggle:ToggleView = ToggleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBaseNavigationTabBarController(for: viewControllers!)
        customizeTabBar(color: .clear, toggleColor: .tabBarItemsColor)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        toggle.moveToggle(to: item.tag, in: tabBar)
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
    
    private func customizeTabBar(color:UIColor, toggleColor: UIColor) {
        
        let toggleWidth:CGFloat = tabBar.frame.width / numberOfItemsInTabBar - 20
        let toggleHeight:CGFloat = 50
        let toggleCoordinateX:CGFloat = tabBar.frame.width / numberOfItemsInTabBar / 2 - toggleWidth / 2
        let toggleCoordinateY:CGFloat = 0
        
        toggle.numberOfItemsInTabBar = numberOfItemsInTabBar
        toggle.frame = CGRect(x: toggleCoordinateX, y: toggleCoordinateY, width: toggleWidth, height: toggleHeight)
        toggle.layer.cornerRadius = toggle.frame.height / 2
        toggle.moveToggle(to: 0, in: tabBar)
        tabBar.addSubview(toggle)
        
    }
}
