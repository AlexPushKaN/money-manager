//
//  DateToString.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 31.05.2023.
//

import Foundation

class DateToString {
    
    let date:Date
    
    init(date: Date) {
        self.date = date
    }
    
    func convertToStringFormateOne () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
