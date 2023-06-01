//
//  Incomes.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 31.05.2023.
//

import Foundation

class Income {
    
    var value:Int
    var date:Date
    
    init(value: Int, date: Date) {
        self.value = value
        self.date = date
    }
}

class Incomes {
    
    var allIncome:[Income]
    
    init(allIncome: [Income]) {
        self.allIncome = allIncome
    }
    
    func calculateAccountAmount() -> Int {
        var balance:Int = 0
        for income in allIncome {
            balance += income.value
        }
        return balance
    }
}
