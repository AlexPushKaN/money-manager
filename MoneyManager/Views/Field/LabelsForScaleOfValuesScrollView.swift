import UIKit

class LabelsForScaleOfValuesScrollView: UIScrollView, PassYcoordinateForlabelDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        showsVerticalScrollIndicator = false
    }
    
    func makeMarkOnValuesScale(yCoordinate: CGFloat, value: Int) {
        let mark = UILabel(frame: CGRect(x: 0.0, y: yCoordinate, width: frame.width, height: 10.0))
        mark.font = UIFont.systemFont(ofSize: 10.0)
        mark.text = String(value)
        mark.sizeToFit()
        mark.center.x = center.x
        mark.textColor = .black
        addSubview(mark)
    }
}
