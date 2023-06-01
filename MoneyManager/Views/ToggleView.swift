//
//  ToggleView.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 29.05.2023.
//

import UIKit

class ToggleView: UIView {

    var numberOfItemsInTabBar:CGFloat = 0
    var textLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tabBarItemsColor
        layer.borderWidth = 5
        layer.borderColor = UIColor.purple.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToggle(to item:Int, in tabBar:UITabBar) {
        
        let xCoordinate = tabBar.frame.width / numberOfItemsInTabBar
        let xFrameCentre = xCoordinate / 2
        addLabel(text: "")
        
        switch item {
        case 0:
            UIView.animate(withDuration: 0.5, delay: 0) { 
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "Доходы")
            }
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "График")
            }
        case 2:
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.center.x = xCoordinate * CGFloat(item) + xFrameCentre
                self.addLabel(text: "Расходы")
            }
        case 3: break // - Если понадобиться добавить еще одну вкладку на tabbar
        case 4: break // - Если понадобиться добавить еще одну вкладку на tabbar
        default: break
        }
    }
    
    private func addLabel(text:String) {
        textLabel.text = text
        textLabel.textColor = .white
        textLabel.sizeToFit()
        textLabel.center = CGPoint(x: bounds.width / CGFloat(2), y: bounds.height / CGFloat(2))
        addSubview(textLabel)
    }
}
