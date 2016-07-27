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

@IBDesignable
public final class SYButton: UIButton, Animatable {
    
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
    @IBInspectable public  var syButtonAnimationAdapter: Int {
        get {
            return syButtonAnimation.rawValue
        }
        set(index) {
            syButtonAnimation = SYButtonAnimation(rawValue: index) ?? .Border
        }
    }
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
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
    
    override public var bounds: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    override public var frame: CGRect {
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
    
    public var isAnimating = false
    
    private lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    private let textLayer = CATextLayer()
    
    private var textColor = UIColor.blackColor() {
        didSet {
            syLayer.setTextColor(textColor)
        }
    }
    
    private var isFirstSetTextLayer = false
    
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
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        guard let title = title else { return }
        super.setTitle(title, forState: state)
        
        !isFirstSetTextLayer ? firstSetTextLayer() : resetTextLayer()
    }
    
    override public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(UIColor.clearColor(), forState: state)
        
        guard let color = color else { return }
        textLayer.foregroundColor = color.CGColor
        textColor = color
    }
    
    public func setFontOfSize(fontSize: CGFloat) {
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        resetTextLayer()
    }
    
    public func setFontNameWithSize(name: String, size: CGFloat) {
        guard let titleLabel = titleLabel else { return }
        
        titleLabel.font = UIFont(name: name, size: size)
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

private extension SYButton {
    
    private func setLayer() {
        layer.cornerRadius = 5.0
        contentEdgeInsets  = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        syLayer.syLayerAnimation = .Border

        setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    private func setTextLayer() {
        guard let font = titleLabel?.font, text = currentTitle else {
            return
        }

        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        
        let size  = text.sizeWithAttributes(attributes)
        let x     = ( CGRectGetWidth(self.frame) - size.width ) / 2
        let y     = ( CGRectGetHeight(self.frame) - size.height ) / 2
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: size.width, height: size.height + layer.borderWidth))

        textLayer.font            = font
        textLayer.string          = text
        textLayer.fontSize        = font.pointSize
        textLayer.foregroundColor = textColor.CGColor
        textLayer.contentsScale   = UIScreen.mainScreen().scale
        textLayer.frame           = frame
        textLayer.alignmentMode   = kCAAlignmentCenter
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
