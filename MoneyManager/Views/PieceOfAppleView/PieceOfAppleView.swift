import UIKit

class PieceOfAppleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 11.0, y: 0.0))
        path.addQuadCurve(to: CGPoint(x: 13.5, y: 34), controlPoint: CGPoint(x: 20.0, y: 15.0))
        path.addQuadCurve(to: CGPoint(x: 10.0, y: 0.0), controlPoint: CGPoint(x: -17.5, y: 22.0))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.3416615725, green: 0.6664956212, blue: 0.8736378551, alpha: 1)
        layer.addSublayer(shapeLayer)
    }
}
