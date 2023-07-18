import Foundation

class DateToString {
    
    let date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    func convertToStringFormateOne () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertToStringFormateTwo () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertToStringFormateThtree() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
