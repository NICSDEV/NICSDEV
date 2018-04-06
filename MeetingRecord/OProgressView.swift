import UIKit

@IBDesignable class OProgressView: UIView {
    
    struct Constant {
        static let lineWidth: CGFloat = 4
        static let trackColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0,
            alpha: 1)
        static let progressColoar = UIColor(red: 0/255.0, green: 112/255.0, blue: 192/255.0,
                                            alpha: 1)    }
    
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    let path = UIBezierPath()
    
    //当前进度
    @IBInspectable var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            }else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: bounds.size.width/2 - Constant.lineWidth,
            startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        layer.addSublayer(progressLayer)
    }
    
    func setProgress(_ pro: Int,animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    func setProgress(_ pro: Int,animated anim: Bool, withDuration duration: Double) {
        progress = pro
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        CATransaction.commit()
    }
    
    fileprivate func angleToRadian(_ angle: Double)->CGFloat {
        return CGFloat(angle/Double(180.0) * double_t.pi)
    }
}
