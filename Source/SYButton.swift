//
//  SYButton.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYButtonAnimation: Int {
    case Border
    case BorderWithShadow
    case Background
    case Ripple
    case Text
}

@IBDesignable public class SYButton: UIButton, Animatable {
    
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

    private var textColor = UIColor.blackColor() {
        didSet {
            syLayer.setTextColor(textColor)
        }
    }
    
    public var isAnimating = false
    
    private var isFirstSetTextLayer = false
    
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
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        guard let t = title else { return }
        super.setTitle(t, forState: state)
        
        !isFirstSetTextLayer ? firstSetTextLayer() : resetTextLayer()
    }
    override public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(UIColor.clearColor(), forState: state)
        
        guard let c = color else { return }
        textLayer.foregroundColor = c.CGColor
        textColor = c
    }
    
    public func setFontOfSize(fontSize: CGFloat) {
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        resetTextLayer()
    }
    public func setFontNameWithSize(name: String, size: CGFloat) {
        guard let tLabel = titleLabel else { return }

        tLabel.font = UIFont(name: name, size: size)
        resetTextLayer()
    }
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    @IBInspectable public  var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .Linear
        }
    }
    
    @IBInspectable public var animationDuration: CGFloat = 1.0 {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
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
    
    public var syButtonAnimation: SYButtonAnimation = .Border {
        didSet {
            switch syButtonAnimation {
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
    @IBInspectable public  var syButtonAnimationAdapter: Int {
        get {
            return syButtonAnimation.rawValue
        }
        set(index) {
            syButtonAnimation = SYButtonAnimation(rawValue: index) ?? .Border
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

private extension SYButton {
    
    private func setLayer() {
        layer.cornerRadius       = 5.0
        contentEdgeInsets        = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        syLayer.syLayerAnimation = .Border

        setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    private func setTextLayer() {
        guard let font = titleLabel?.font, text = currentTitle else {
            return
        }

        var attributes                  = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let size                        = text.sizeWithAttributes(attributes)

        let x                           = ( CGRectGetWidth(self.frame) - size.width ) / 2
        let y                           = ( CGRectGetHeight(self.frame) - size.height ) / 2
        let frame                       = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: size.width, height: size.height + layer.borderWidth))

        textLayer.font                  = font
        textLayer.string                = text
        textLayer.fontSize              = font.pointSize

        textLayer.foregroundColor       = textColor.CGColor
        textLayer.contentsScale         = UIScreen.mainScreen().scale

        textLayer.frame                 = frame
        textLayer.alignmentMode         = kCAAlignmentCenter
    }
    
    private func firstSetTextLayer() {
        isFirstSetTextLayer = true
        setTextLayer()
        syLayer.firstSetTextLayer(textLayer)
    }
    
    private func resetTextLayer(){
        setTextLayer()
        syLayer.resetTextLayer(textLayer)
    }
}
