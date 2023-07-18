import Foundation

class Income: UniversalProtocol {
    
    var id: UUID
    var value: Int
    var date: Date
    
    init(id: UUID, value: Int, date: Date) {
        self.id = id
        self.value = value
        self.date = date
    }
}

class Incomes {
    
    var allIncome: [Income]
    
    init(allIncome: [Income]) {
        self.allIncome = allIncome
    }
    
    func calculateAccountAmount() -> Int {
        var balance: Int = 0
        for income in allIncome {
            balance += income.value
        }
        return balance
    }
}
