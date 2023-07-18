import UIKit

protocol UniversalProtocol {
    var value: Int { get }
    var date: Date { get }
}

protocol PassXcoordinateForlabelDelegate: AnyObject {
    func makeMarkOnDatesScale(xCoordinate: CGFloat, date: Date)
}

protocol PassYcoordinateForlabelDelegate: AnyObject {
    func makeMarkOnValuesScale(yCoordinate: CGFloat, value: Int)
}

protocol PresentAlertDelegate: AnyObject {
    func present(alert: UIAlertController)
}

protocol PresentCategoryExpensesViewControllerDelegate: AnyObject {
    func present(viewController: UIViewController)
}

protocol InputViewForDigitDelegate {
    func send(digit: Int)
}

protocol InputViewForTextDelegate {
    func send(text: String)
}

protocol InputViewForAllDelegate {
    func send(digit: Int, text: String)
}

protocol RemoveFromSuperViewDelegate: AnyObject {
    func removeFromSuperView()
}
