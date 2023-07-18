import UIKit

class FieldForGraphsView: UIView {
    
    weak var delegateXCoordinate: PassXcoordinateForlabelDelegate?
    weak var delegateYCoordinate: PassYcoordinateForlabelDelegate?
    
    let cellWidthAndHeight: CGFloat
    
    init(field: Field, scales: Scales, labelsForScaleOfValuesScrollView: LabelsForScaleOfValuesScrollView, labelsForScaleOfDatesScrollView: LabelsForScaleOfDatesScrollView) {
        
        self.cellWidthAndHeight = field.cellWidthAndHeight
        
        super.init(frame: field.frame)
        
        let numberOfVerticalLines = Int(frame.height / cellWidthAndHeight)
        let numberOfHorizontalLines = Int(frame.width / cellWidthAndHeight)
        delegateXCoordinate = labelsForScaleOfDatesScrollView as PassXcoordinateForlabelDelegate
        delegateYCoordinate = labelsForScaleOfValuesScrollView as PassYcoordinateForlabelDelegate
        
        configureLines(field: field, scales: scales, gorizontal: numberOfHorizontalLines, vertical: numberOfVerticalLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLines(field: Field, scales: Scales, gorizontal: Int, vertical: Int) {
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = bounds

        var yCoordinate: CGFloat = 0.0
        var xCoordinate: CGFloat = 0.0

        for (orientationLineIndex, lines) in [gorizontal, vertical].enumerated() {
            for lineIndex in 0...lines - 1 {
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.strokeColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1).withAlphaComponent(0.5).cgColor
                shapeLayer.lineWidth = 1.0
                shapeLayer.path = getPathFor(orientation: orientationLineIndex, line: lineIndex, scales: scales).cgPath
                layer.addSublayer(shapeLayer)
            }
        }
        
        func getPathFor(orientation: Int, line: Int, scales: Scales) -> UIBezierPath {
            
            let path = UIBezierPath()

            if orientation == 0 {
                path.move(to: CGPoint(x: xCoordinate, y: 0.0))
                path.addLine(to: CGPoint(x: xCoordinate, y: frame.height))
                delegateXCoordinate?.makeMarkOnDatesScale(xCoordinate: xCoordinate, date: scales.dates[line])
                xCoordinate = xCoordinate + cellWidthAndHeight
                
            } else {
                path.move(to: CGPoint(x: 0.0, y: yCoordinate))
                path.addLine(to: CGPoint(x: frame.width, y: yCoordinate))
                delegateYCoordinate?.makeMarkOnValuesScale(yCoordinate: yCoordinate, value: scales.values[line])
                yCoordinate = yCoordinate + cellWidthAndHeight
            }

            return path
        }
        
        self.layer.addSublayer(layer)
    }
}
