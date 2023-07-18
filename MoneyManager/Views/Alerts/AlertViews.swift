import UIKit

enum PointAssignment {
    case forPointIncome(Income)
    case forPointCategoryExpenses(CategoryExpenses)
    case forPointExpense(Expense)
}

enum TypesOfAlert {
    case registrationAgain
    case inputName
    case inputPassword
    case updateData
    case isInternetAvailable
    case isNoDataForGraph
}


class Alerts {

    static func create(forAssigment: PointAssignment, completion:((UniversalProtocol) -> Void)? = nil) -> UIAlertController {
        
        switch forAssigment {
            
        case .forPointIncome(let object):
            let date = object.date
            let value = object.value
            let alert = UIAlertController(title: "Поступление средств в размере: \(value) рублей", message: "Время транзакции: \(date)", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ясно", style: .destructive)
            alert.addAction(actionOK)
            return alert
            
        case .forPointCategoryExpenses(let object):
            let date = object.date
            let value = object.value
            let name = object.name
            let alert = UIAlertController(title: "Ваши расходы по категории \(name) составили: \(value) рублей", message: "Первая операция по категории была выполнена: \(date)", preferredStyle: .alert)
            let actionTransitionToDetail = UIAlertAction(title: "Перейти к детализации категории", style: .default) { _ in
                completion?(object)
            }
            let actionOK = UIAlertAction(title: "Ясно", style: .destructive)
            alert.addAction(actionTransitionToDetail)
            alert.addAction(actionOK)
            return alert
            
        case .forPointExpense(let object):
            let date = object.date
            let value = object.value
            let alert = UIAlertController(title: "Ваш расход составил: \(value) рублей", message: "Время транзакции: \(date)", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ясно", style: .destructive)
            alert.addAction(actionOK)
            return alert
        }
    }
    
    static func show(alert typeAlert: TypesOfAlert, title: String, message: String, completion: ((Bool) -> Void)? = nil) -> UIAlertController {
        
        switch typeAlert {
        
        case .registrationAgain:
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionDeleteAccount = UIAlertAction(title: "Продолжить", style: .destructive) {_ in
                completion?(true)
            }
            let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(actionDeleteAccount)
            alert.addAction(actionCancel)
            return alert
            
        case .inputName, .inputPassword, .isNoDataForGraph:
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ок", style: .destructive)
            alert.addAction(actionOK)
            return alert
            
        case .updateData:
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ok", style: .default) {_ in
                completion?(true)
            }
            let actionLater = UIAlertAction(title: "Later", style: .destructive) {_ in
                completion?(false)
            }
            alert.addAction(actionOK)
            alert.addAction(actionLater)
            return alert
            
        case .isInternetAvailable:
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ok", style: .destructive) {_ in
                completion?(true)
            }
            alert.addAction(actionOK)
            return alert
        }
    }
}
