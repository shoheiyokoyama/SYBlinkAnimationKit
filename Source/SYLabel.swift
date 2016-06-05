//
//  SYLabel.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYLabelAnimation: Int {
    case Border
    case BorderWithShadow
    case Background
    case Ripple
    case Text
}

@IBDesignable public class SYLabel: UILabel, Animatable {
    
    private let textLayer = CATextLayer()
    
    @IBInspectable public var animationBorderColor: UIColor = UIColor() {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor: UIColor = UIColor() {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationTextColor: UIColor = UIColor() {
        didSet {
            syLayer.setAnimationTextColor(animationTextColor)
        }
    }
    @IBInspectable public var animationRippleColor: UIColor = UIColor() {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
        }
    }
    
    override public var frame: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    override public var bounds: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard let bgColor = backgroundColor else { return }
            syLayer.setBackgroundColor(bgColor)
        }
    }
    
    override public var text: String? {
        didSet {
            !isFirstSetTextLayer ? firstSetTextLayer() : resetTextLayer()
        }
    }
    
    @IBInspectable public var labelTextColor: UIColor? {
        didSet {
            guard let ltColor = labelTextColor else { return }
            textColor = UIColor.clearColor()
            textLayer.foregroundColor = ltColor.CGColor
            syLayer.setTextColor(ltColor)
        }
    }
    
    public var isAnimating = false
    public var isFirstSetTextLayer = false
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .Linear
        }
    }
    
    @IBInspectable public var animationDuration: CGFloat = 1.0 {
        didSet {
            syLayer.setAnimationDuration(CFTimeInterval(animationDuration))
        }
    }
    
    public func setFontOfSize(fontSize: CGFloat) {
        font = UIFont.systemFontOfSize(fontSize)
        resetTextLayer()
    }
    public func setFontNameWithSize(name: String, size: CGFloat) {
        font = UIFont(name: name, size: size)
        resetTextLayer()
    }
    
    private lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayer()
    }
    
    public var syLabelAnimation: SYLabelAnimation = .Border {
        didSet {
            switch syLabelAnimation {
            case .Border:
                syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                syLayer.syLayerAnimation = .Background
            case .Ripple:
                syLayer.syLayerAnimation = .Ripple
            case .Text:
                syLayer.syLayerAnimation = .Text
            }
        }
    }
    @IBInspectable public  var syLabelAnimationAdapter: Int {
        get {
            return syLabelAnimation.rawValue
        }
        set(index) {
            syLabelAnimation = SYLabelAnimation(rawValue: index) ?? .Border
        }
    }
    
    public func startAnimation() {
        isAnimating = true
        syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        isAnimating = false
        syLayer.stopAnimation()
    }
}

private extension SYLabel {
    
    private func setLayer() {
        layer.cornerRadius       = 1.5
        textColor                = UIColor.clearColor()
        labelTextColor           = UIColor.blackColor()
        syLayer.syLayerAnimation = .Border
    }
    
    private func firstSetTextLayer() {
        isFirstSetTextLayer = true
        setTextLayer()
        syLayer.firstSetTextLayer(textLayer)
    }
    
    private func resetTextLayer() {
        setTextLayer()
        syLayer.resetTextLayer(textLayer)
    }
    
    private func setTextLayer() {
        guard let t = text else {
            return
        }

        var attributes                  = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let size                        = t.sizeWithAttributes(attributes)
        
        let x                           = ( CGRectGetWidth(self.frame) - size.width ) / 2
        let y                           = ( CGRectGetHeight(self.frame) - size.height ) / 2
        let frame                       = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: size.width, height: size.height + layer.borderWidth))

        textLayer.font                  = font
        textLayer.string                = t
        textLayer.fontSize              = font.pointSize

        if let ltColor = labelTextColor {
            textLayer.foregroundColor = ltColor.CGColor
        }

        textLayer.contentsScale         = UIScreen.mainScreen().scale

        textLayer.frame                 = frame
        textLayer.alignmentMode         = kCAAlignmentCenter
    }
}