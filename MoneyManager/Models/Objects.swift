import Foundation

enum Objects {
    
    case incomes(_: Incomes)
    case categoryExpenses(_: CategoryExpenses)
    case expenses(_: Expenses)
    
    func get() -> AnyObject {
        
        switch self {
        case .incomes(let incomes): return incomes
        case .categoryExpenses(let categoryExpenses): return categoryExpenses
        case .expenses(let expenses): return expenses
        }
    }
}
