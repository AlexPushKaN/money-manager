import UIKit

extension UISegmentedControl {
    
    enum TimePeriod {
        case week
        case month
        case quarter
        case all
    }
    
    func setSelectedSegment(for period: TimePeriod) -> Int {
        switch period {
        case .week: return 0
        case .month: return 1
        case .quarter: return 2
        case .all: return 3
        }
    }
}
