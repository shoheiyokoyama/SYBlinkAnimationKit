//
//  SYTextField.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

@IBDesignable
public final class SYTextField: UITextField, AnimatableComponent {
    
    public enum AnimationType: Int {
        case border
        case borderWithShadow
        case background
        case ripple
    }

    @IBInspectable public var animationBorderColor:UIColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor:UIColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationRippleColor:UIColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .linear
        }
    }
    @IBInspectable public var animationDuration: CGFloat = TextFieldConstants.defaultDuration {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    @IBInspectable public  var syTextFieldAnimationAdapter: Int {
        get {
            return animationType.rawValue
        }
        set(index) {
            animationType = AnimationType(rawValue: index) ?? .border
        }
    }
    @IBInspectable public var stopAnimationWithTouch = true
    
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
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if stopAnimationWithTouch && isAnimating {
            stopAnimation()
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override public var borderStyle: UITextBorderStyle {
        didSet {
            switch borderStyle {
            case .Bezel:
                self.layer.cornerRadius = 0
            case .Line:
                self.layer.cornerRadius = 0
            case .None:
                self.layer.cornerRadius = TextFieldConstants.cornerRadius
            case .RoundedRect:
                self.layer.cornerRadius = TextFieldConstants.cornerRadius
            }
        }
    }
    override public var backgroundColor: UIColor? {
        didSet {
            guard let backgroundColor = backgroundColor else { return }
            
            syLayer.setBackgroundColor(backgroundColor)
            originalBackgroundColor = backgroundColor
        }
    }
    
    public var isAnimating = false
    
    public var animationTimingFunction: SYMediaTimingFunction = .linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    public var animationType: AnimationType = .border {
        didSet {
            switch animationType {
            case .border:
                syLayer.animationType = .border
            case .borderWithShadow:
                syLayer.animationType = .borderWithShadow
            case .background:
                syLayer.animationType = .background
            case .ripple:
                syLayer.animationType = .ripple
                
            }
        }
    }
    
    private var originalBackgroundColor = UIColor.whiteColor()
    
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
    
    public func startAnimation() {
        isAnimating = true
        if animationType == .background && borderStyle == .RoundedRect {
            backgroundColor = UIColor.clearColor()
        }
        
        syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        isAnimating = false
        if animationType == .background &&  borderStyle == .RoundedRect {
            backgroundColor = originalBackgroundColor
        }
        syLayer.stopAnimation()
    }
}

// MARK: - Private Methods -

private extension SYTextField {
    
    private struct TextFieldConstants {
        static let cornerRadius: CGFloat    = 5
        static let defaultDuration: CGFloat = 1
    }
    
    private func setLayer() {
        syLayer.animationType = .border
        borderStyle = .RoundedRect
    }
}
