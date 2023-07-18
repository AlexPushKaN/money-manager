import Foundation

class Field {
    
    let cellWidthAndHeight: CGFloat
    let numberOfCellVertically: Int
    let numberOfCellsHorizontally: Int
    var frame: CGRect {
        return CGRect(x: 0, y: 0, width: CGFloat(numberOfCellsHorizontally) * cellWidthAndHeight, height: CGFloat(numberOfCellVertically) * cellWidthAndHeight)
    }
    
    init(heightField: CGFloat, periodIndex: Int, amountOfDay: Int, cellWidthAndHeight: CGFloat) {

        switch periodIndex {
        case 0: self.numberOfCellsHorizontally = 7
        case 1: self.numberOfCellsHorizontally = 30
        case 2: self.numberOfCellsHorizontally = 90
        case 3: self.numberOfCellsHorizontally = amountOfDay < 7 ? 7 : amountOfDay
        default: self.numberOfCellsHorizontally = 0
        }
        
        self.cellWidthAndHeight = cellWidthAndHeight
        self.numberOfCellVertically = Int(heightField / cellWidthAndHeight) + 1
    }
}
