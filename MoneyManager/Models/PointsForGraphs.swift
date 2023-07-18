import Foundation

class PointsForGraphs {
    
    var startDate: Date
    var variableDate: Date?
    let width: CGFloat
    let height: CGFloat
    let cellWidthAndHeight: CGFloat
    let hoursInDay: Int = 24
    
    init(startDate: Date, fieldForGraphs: Field, cellWidthAndHeight: CGFloat) {
        self.startDate = startDate
        self.width = fieldForGraphs.frame.width
        self.height = fieldForGraphs.frame.height
        self.cellWidthAndHeight = cellWidthAndHeight
    }
    
    func createAndGetPoints(from objects: [UniversalProtocol], maxValueOnValueScale: Int?) -> [PointView] {
        
        var points: [PointView] = []
        var coordinateX: CGFloat = 0.0
        var coordinateY: CGFloat = 0.0
        var deltaX: CGFloat = 0.0
        variableDate = startDate
        
        for object in objects where object.value > 0 {

            let differenceDays = PointsForGraphs.calculateDifferenceDays(beetwen: object.date, and: variableDate)

            if differenceDays > 0 {
                deltaX += CGFloat(differenceDays) * cellWidthAndHeight
            }
            
            coordinateX = deltaX + (CGFloat(Calendar.current.component(.hour, from: object.date) - 4) / CGFloat(hoursInDay) * cellWidthAndHeight)
            variableDate = object.date
            
            if let maxValue = maxValueOnValueScale {
                coordinateY = height - (CGFloat(object.value) / CGFloat(maxValue) * height)
            }
            
            let pointView = PointView(frame: CGRect(x: coordinateX, y: coordinateY, width: 10.0, height: 10.0), object: object)
            points.append(pointView)
            
        }
        
        return points
    }
    
    static func calculateDifferenceDays(beetwen currentDate: Date, and previousDate: Date?) -> Int {
        
        let calendar: Calendar = Calendar.current
        let dateComponentsForCurrentDate = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let dateComponentsForPreviousDate = calendar.dateComponents([.year, .month, .day], from: previousDate ?? currentDate)
        
        guard let currentDate = calendar.date(from: dateComponentsForCurrentDate),
              let lastDate = calendar.date(from: dateComponentsForPreviousDate) else { return 0 }
        
        return calendar.dateComponents([.day], from: lastDate, to: currentDate).day ?? 0
    }
}
