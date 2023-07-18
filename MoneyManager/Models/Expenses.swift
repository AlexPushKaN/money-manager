import Foundation

class Expense: UniversalProtocol {
    
    var id: UUID
    var value: Int
    var date: Date
    var name: String
    
    init(id: UUID, value: Int, date: Date, name: String) {
        self.id = id
        self.value = value
        self.date = date
        self.name = name
    }
}

class CategoryExpenses {
    var id: UUID
    var name: String
    var allExpense: [Expense]
    
    init(id: UUID, name: String, allExpense: [Expense]) {
        self.id = id
        self.name = name
        self.allExpense = allExpense
    }
    
    func calculateCategory() -> Int {
        var totalСostsByCategory:Int = 0
        for expense in allExpense {
            totalСostsByCategory += expense.value
        }
        return totalСostsByCategory
    }
}

class Expenses {
    
    var allCategoriesExpenses:[CategoryExpenses]
    
    init(allCategoriesExpenses: [CategoryExpenses]) {
        self.allCategoriesExpenses = allCategoriesExpenses
    }
    
    func calculateTotalCosts() -> Int {
        var totalCosts:Int = 0
        for categoryExpenses in allCategoriesExpenses {
            totalCosts += categoryExpenses.calculateCategory()
        }
        return totalCosts
    }
}
