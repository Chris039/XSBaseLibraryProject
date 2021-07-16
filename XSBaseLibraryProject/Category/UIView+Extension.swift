//
//  UIView+Extension.swift
//  BSBDJ
//
//  Created by apple on 2017/11/6.
//  Copyright © 2017年 incich. All rights reserved.
//

import UIKit


// MARK: 坐标尺寸
extension UIView {
    
    /// Frame中的坐标
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            var rect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
    }
    
    /// View宽
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width = newValue
            self.frame = tmpFrame
        }
    }
    
    /// View高
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    var bottom: CGFloat {
        get {
            return (top + height)
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.y = (newValue - height)
            self.frame = rect
        }
    }
    
    var right:CGFloat {
        get {
            return (left + width)
        }
        set(newValue) {
            var rect = self.frame
            rect.origin.x = (newValue - self.frame.size.width)
            self.frame = rect
        }
    }
    
    var size:CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var rect = self.frame
            rect.size = newValue
            self.frame = rect
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
}

extension UIView { // 按钮和UIView的事件
    
    private static var blockKey = "blockKey"
    
    private var block: (()->())? {
        get{ return objc_getAssociatedObject(self, &UIView.blockKey) as? ()->() }
        set{ objc_setAssociatedObject(self, &UIView.blockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    func addTap(_ aBlock: @escaping ()->()) {
        block = aBlock
        isUserInteractionEnabled = true
        if let button = self as? UIButton {
            button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        } else {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            addGestureRecognizer(tap)
        }
    }
    
    @objc private func tapAction() {
        block?()
    }
}

extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    func addSubviews(_ subviews: [UIView]) {
        guard !subviews.isEmpty else {
            return
        }
        subviews.forEach {
            self.addSubview($0)
        }
    }
    
    func removeAllSubviews()  {
        self.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
    
    func makeImageWithView() -> UIImage?  {
        guard self.bounds.size != CGSize.zero else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - 增加是否在当前显示的窗口
extension UIView {

    public func isShowingnKeyWindow() -> Bool {

        guard let keyWindow = UIApplication.shared.keyWindow else {
            return false
        }

        //以主窗口的左上角为原点, 计算self的矩形框(谁调用这个方法这个self就是谁)
        let frame = keyWindow.convert(self.frame, from: self.superview)

        //判断主窗口的bounds和self的范围是否有重叠
        let isIntersects = frame.intersects(keyWindow.bounds)
        return isIntersects && !self.isHidden && self.alpha > 0 && self.window == keyWindow
    }
}


// MARK: - 获得View的上下左右中心点(x, y)
extension UIView {
    
    // height
    var zc_height : CGFloat {
        get {
            return frame.size.height
        }

        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }

    // width
    var zc_width : CGFloat {
        get {
            return frame.size.width
        }

        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }

    //x
    var zc_x: CGFloat {
        get {
            return frame.origin.x
        }
        set{
            var tempFrame: CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }

    // y

    var zc_y: CGFloat {
        set {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
        get {
            return frame.origin.y

        }

    }

    // left
    var zc_left : CGFloat {
        get {
            return zc_x
        }

        set(newVal) {
            zc_x = newVal
        }
    }

    // right
    var zc_right : CGFloat {
        get {
            return zc_x + zc_width
        }

        set(newVal) {
            zc_x = newVal - zc_width
        }
    }

    // bottom
    var zc_bottom : CGFloat {
        get {
            return zc_y + zc_height
        }

        set(newVal) {
            zc_y = newVal - zc_height
        }
    }


//自身中心点
    var zc_center: CGPoint {
        get {
            return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        }
        set {
            center = CGPoint(x: newValue.x, y: newValue.y)
        }

    }
    
    //中心点x
    var zc_centerX : CGFloat {
        get {
            return center.x
        }
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    //中心点y
    var zc_centerY : CGFloat {
        get {
            return center.y
        }
        
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
}

private var LW_redDotKey = 105

extension UIView {
    
    var redDot: UIView? {
        set {
            objc_setAssociatedObject(self, &LW_redDotKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &LW_redDotKey) as? UIView
        }
    }
    
    func clearRedDot() {
        redDot?.removeFromSuperview()
        redDot = nil
    }
    
    func showRedDot() {
        let width: CGFloat = 8
        if redDot == nil {
            redDot = UIView(backgroundColor: .red)
            redDot?.layer.cornerRadius = width / 2
            self.addSubview(redDot!)
        }
        redDot?.snp.makeConstraints({ (make) in
            make.width.height.equalTo(width)
            make.left.equalTo(self.snp.right)
            make.centerY.equalTo(self.snp.top)
        })
    }
}

// MARK: - 约束拓展
extension UIView {
    
    /*----------------------------添加约束----------------------------*/
    
    /// 添加约束 -> edgeInsets
    func addLayoutConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        addLayoutConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 添加约束 -> [attr1]丶toItem丶[attr2]丶constant
    func addLayoutConstraints(attributes attr1s: [NSLayoutConstraint.Attribute],
                              toItem: Any?,
                              attributes attr2s: [NSLayoutConstraint.Attribute]?,
                              constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            addLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 添加约束 -> [attr1]丶toItem丶[attr2]丶[constant]
    func addLayoutConstraints(attributes attr1s: [NSLayoutConstraint.Attribute],
                              toItem: Any?,
                              attributes attr2s: [NSLayoutConstraint.Attribute]?,
                              constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            let constant = constants[i]
            addLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 添加约束 -> attr1丶toItem丶attr2丶constant
    func addLayoutConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                             toItem: Any?,
                             attribute attr2: NSLayoutConstraint.Attribute?,
                             constant: CGFloat) {
        addLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 添加约束 -> attr1丶relatedBy丶toItem丶attr2丶multiplier丶constant
    func addLayoutConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                             relatedBy relation: NSLayoutConstraint.Relation,
                             toItem: Any?,
                             attribute attr2: NSLayoutConstraint.Attribute?,
                             multiplier: CGFloat,
                             constant: CGFloat) {
        
        var toItem = toItem
        var attr2 = attr2 ?? attr1
        
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        if attr1 == .width || attr1 == .height {
            toItem = nil
            attr2 = .notAnAttribute
        }
        
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    /*----------------------------修改约束----------------------------*/
    
    /// 修改约束 -> edgeInsets
    func updateLayoutConstraints(toItem: Any,edgeInsets: UIEdgeInsets) {
        updateLayoutConstraints(attributes: [.top,.bottom,.left,.right], toItem: toItem, attributes: nil, constants:[edgeInsets.top,edgeInsets.bottom,edgeInsets.left,edgeInsets.right])
        
    }
    /// 修改约束 -> [attr1]丶toItem丶[attr2]丶constant
    func updateLayoutConstraints(attributes attr1s: [NSLayoutConstraint.Attribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutConstraint.Attribute]?,
                                 constant: CGFloat) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            updateLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
        }
    }
    /// 修改约束 -> [attr1]丶toItem丶[attr2]丶[constant]
    func updateLayoutConstraints(attributes attr1s: [NSLayoutConstraint.Attribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutConstraint.Attribute]?,
                                 constants: [CGFloat]) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? attr1:attr2s![i]
            let constant = constants[i]
            updateLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2, constant: constant)
        }
    }
    /// 修改约束 -> attr1丶toItem丶attr2丶constant
    func updateLayoutConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                                toItem: Any?,
                                attribute attr2: NSLayoutConstraint.Attribute?,
                                constant: CGFloat) {
        updateLayoutConstraint(attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant)
    }
    /// 修改约束 -> attr1丶relatedBy丶toItem丶attr2丶multiplier丶constant
    func updateLayoutConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                                relatedBy relation: NSLayoutConstraint.Relation,
                                toItem: Any?,
                                attribute attr2: NSLayoutConstraint.Attribute?,
                                multiplier: CGFloat,
                                constant: CGFloat) {
        
        removeLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        
        addLayoutConstraint(attribute: attr1, relatedBy: relation, toItem: toItem, attribute: attr2, multiplier: multiplier, constant: constant)
    }
    
    /*----------------------------删除约束----------------------------*/
    
    /// 删除约束 -> [attr1]丶toItem丶[attr2]
    func removeLayoutConstraints(attributes attr1s: [NSLayoutConstraint.Attribute],
                                 toItem: Any?,
                                 attributes attr2s: [NSLayoutConstraint.Attribute]?) {
        for (i,attr1) in attr1s.enumerated() {
            let attr2 = attr2s == nil ? nil:attr2s![i]
            removeLayoutConstraint(attribute: attr1, toItem: toItem, attribute: attr2)
        }
    }
    /// 删除约束 -> attr1丶toItem丶attr2
    func removeLayoutConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                                toItem: Any?,
                                attribute attr2: NSLayoutConstraint.Attribute?) {
        
        let attr2 = attr2 ?? attr1
        
        if attr1 == .width  || attr1 == .height {
            for constraint in constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
            
        }else if let superview = self.superview {
            for constraint in superview.constraints {
                if constraint.firstItem?.isEqual(self) == true &&
                    constraint.firstAttribute == attr1 &&
                    constraint.secondItem?.isEqual(toItem) == true &&
                    constraint.secondAttribute == attr2 {
                    NSLayoutConstraint.deactivate([constraint])
                }
            }
        }
    }
}

//MARK: 添加渐变色
extension UIView {
    
    // MARK: 添加渐变色图层
        public func gradientColor(startPoint: CGPoint, endPoint: CGPoint, colors: [Any]) {
            
            guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
                return
            }
            
            // 外界如果改变了self的大小，需要先刷新
            layoutIfNeeded()
            
            var gradientLayer: CAGradientLayer!
            
            removeGradientLayer()

            gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.layer.bounds
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.colors = colors
            gradientLayer.cornerRadius = self.layer.cornerRadius
            gradientLayer.masksToBounds = true
            // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
            self.layer.insertSublayer(gradientLayer, at: 0)
            self.backgroundColor = UIColor.clear
            // self如果是UILabel，masksToBounds设为true会导致文字消失
            self.layer.masksToBounds = false
        }
        
        // MARK: 移除渐变图层
        // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
        public func removeGradientLayer() {
            if let sl = self.layer.sublayers {
                for layer in sl {
                    if layer.isKind(of: CAGradientLayer.self) {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    
}

extension UIView {
    
    // MARK: - 位移
    
    // 移动到指定中心点位置
    func moveToPoint(point:CGPoint) -> Void
    {
        var center = self.center
        center.x = point.x
        center.y = point.y
        self.center = center
    }
    
    // 缩放到指定大小
    func scaleToSize(scale:CGFloat) -> Void
    {
        var rect = self.frame
        rect.size.width *= scale
        rect.size.height *= scale
        self.frame = rect
    }
    
    // MARK: - 毛玻璃效果
    
    // 毛玻璃
    func effectViewWithAlpha(alpha:CGFloat) -> Void
    {
        let effect = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
    
    // MARK: - 边框属性
    
    // 圆角边框设置
    func layer(radius:CGFloat, borderWidth:CGFloat, borderColor:UIColor) -> Void
    {
        if (0.0 < radius)
        {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
            self.clipsToBounds = true
        }
        
        if (0.0 < borderWidth)
        {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
//    func setupCorner(_ corner: UIRectCorner, cornerRadii: CGSize){
//        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: cornerRadii)
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = self.bounds
//        shapeLayer.path = bezierPath.cgPath
//        self.layer.mask = shapeLayer
//    }
    
    // MARK: - 翻转
    
    // 旋转 旋转180度 M_PI
    func viewTransformWithRotation(rotation:CGFloat) -> Void
    {
        self.transform = CGAffineTransform(rotationAngle: rotation);
    }
    
    // 缩放
    func viewScaleWithSize(size:CGFloat) -> Void
    {
        self.transform = self.transform.scaledBy(x: size, y: size);
    }
    
    // 水平，或垂直翻转
    func viewFlip(isHorizontal:Bool) -> Void
    {
        if (isHorizontal)
        {
            // 水平
            self.transform = self.transform.scaledBy(x: -1.0, y: 1.0);
        }
        else
        {
            // 垂直
            self.transform = self.transform.scaledBy(x: 1.0, y: -1.0);
        }
    }
    
}
