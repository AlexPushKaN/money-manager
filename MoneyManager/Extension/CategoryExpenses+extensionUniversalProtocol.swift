import Foundation

extension CategoryExpenses: UniversalProtocol {
    var value: Int {
        calculateCategory()
    }
    
    var date: Date {
        return allExpense.first!.date
    }
}
