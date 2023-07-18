import UIKit

class LabelsForScaleOfDatesScrollView: UIScrollView, PassXcoordinateForlabelDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        showsHorizontalScrollIndicator = false
    }
    
    func makeMarkOnDatesScale(xCoordinate: CGFloat, date: Date) {
        let mark = UILabel(frame: CGRect(x: xCoordinate + 10.0, y: 10.0, width: 30.0, height: 10.0))
        mark.font = UIFont.systemFont(ofSize: 10.0)
        mark.text = DateToString(date: date).convertToStringFormateTwo()
        mark.sizeToFit()
        mark.textColor = .black
        addSubview(mark)
    }
}
