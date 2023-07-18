import UIKit

class LinesOnFieldView {
    
    var point: CGPoint
    var lineColor: UIColor
    
    init(startPoint: CGPoint, lineColor: UIColor) {
        self.point = startPoint
        self.lineColor = lineColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(on fieldForGraphsView: FieldForGraphsView, nextPoint: CGPoint) {
        if point != nextPoint {
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 5.0
            shapeLayer.strokeColor = lineColor.cgColor
            let path = UIBezierPath()
            path.move(to: point)
            path.addLine(to: nextPoint)
            shapeLayer.path = path.cgPath
            fieldForGraphsView.layer.addSublayer(shapeLayer)
            point = nextPoint
        }
    }
}
