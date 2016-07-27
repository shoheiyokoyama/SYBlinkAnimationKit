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
public final class SYButton: UIButton, Animatable, TextConvertible {
    
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
    @IBInspectable public  var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .Linear
        }
    }
    @IBInspectable public var animationDuration: CGFloat = ButtonConstants.defaultDuration {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    @IBInspectable public var syButtonAnimationAdapter: Int {
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
            guard let backgroundColor = backgroundColor else { return }
            syLayer.setBackgroundColor(backgroundColor)
        }
    }
    
    public var isAnimating = false
    
    var textLayer = CATextLayer()
    
    private lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    private var textColor = UIColor.blackColor() {
        didSet {
            syLayer.setTextColor(textColor)
        }
    }
    
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
        
        resetTextLayer()
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
    
    private struct ButtonConstants {
        static let cornerRadius: CGFloat    = 5
        static let padding: CGFloat         = 5
        static let defaultDuration: CGFloat = 1
    }
    
    private func setLayer() {
        layer.cornerRadius = ButtonConstants.cornerRadius
        contentEdgeInsets  = UIEdgeInsets(top: ButtonConstants.padding, left: ButtonConstants.padding, bottom: ButtonConstants.padding, right: ButtonConstants.padding)
        
        syLayer.syLayerAnimation = .Border

        setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    private func resetTextLayer(){
        configureTextLayer(currentTitle, font: titleLabel?.font, textColor: textColor)
        syLayer.resetTextLayer(textLayer)
    }
}
