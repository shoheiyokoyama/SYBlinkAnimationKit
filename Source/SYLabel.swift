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

@IBDesignable
public final class SYLabel: UILabel, Animatable {
    
    @IBInspectable public var animationBorderColor: UIColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor: UIColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationTextColor: UIColor = AnimationDefaultColor.text {
        didSet {
            syLayer.setAnimationTextColor(animationTextColor)
        }
    }
    @IBInspectable public var animationRippleColor: UIColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
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
    @IBInspectable public var animationDuration: CGFloat = LabelConstants.defaultDuration {
        didSet {
            syLayer.setAnimationDuration(CFTimeInterval(animationDuration))
        }
    }
    @IBInspectable public var labelTextColor: UIColor? {
        didSet {
            guard let labelTextColor = labelTextColor else { return }
            
            textColor = UIColor.clearColor()
            textLayer.foregroundColor = labelTextColor.CGColor
            syLayer.setTextColor(labelTextColor)
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
            guard let backgroundColor = backgroundColor else { return }
            syLayer.setBackgroundColor(backgroundColor)
        }
    }
    override public var text: String? {
        didSet {
            !isFirstSetTextLayer ? firstSetTextLayer() : resetTextLayer()
        }
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
    
    public var isAnimating = false
    
    public var isFirstSetTextLayer = false
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    private let textLayer = CATextLayer()
    private lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    // MARK: - initializer -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayer()
    }
    
    // MARK: - Public Methods -
    
    public func setFontOfSize(fontSize: CGFloat) {
        font = UIFont.systemFontOfSize(fontSize)
        resetTextLayer()
    }
    
    public func setFontNameWithSize(name: String, size: CGFloat) {
        font = UIFont(name: name, size: size)
        resetTextLayer()
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

// MARK: - Private Methods -

private extension SYLabel {
    
    private struct LabelConstants {
        static let cornerRadius: CGFloat    = 1.5
        static let defaultDuration: CGFloat = 1
    }
    
    private func setLayer() {
        layer.cornerRadius = LabelConstants.cornerRadius
        
        textColor      = UIColor.clearColor()
        labelTextColor = UIColor.blackColor()
        
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
        guard let text = text else {
            return
        }

        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        
        let size  = text.sizeWithAttributes(attributes)
        let x     = ( self.frame.width - size.width ) / 2
        let y     = ( self.frame.height - size.height ) / 2
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: size.width, height: size.height + layer.borderWidth))

        textLayer.font     = font
        textLayer.string   = text
        textLayer.fontSize = font.pointSize

        if let ltColor = labelTextColor {
            textLayer.foregroundColor = ltColor.CGColor
        }

        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.frame         = frame
        textLayer.alignmentMode = kCAAlignmentCenter
    }
}