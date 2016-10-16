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
        case border, borderWithShadow, background, ripple
    }

    @IBInspectable public var animationBorderColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationRippleColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setRippleColor(animationRippleColor)
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
    @IBInspectable public var animationDuration: CGFloat = 1.5 {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    @IBInspectable public  var animationAdapter: Int {
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
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if stopAnimationWithTouch && isAnimating {
            stopAnimating()
        }
        
        return super.beginTracking(touch, with: event)
    }
    override public var borderStyle: UITextBorderStyle {
        didSet {
            self.layer.cornerRadius = {
                switch borderStyle {
                case .bezel, .line:
                    return CGFloat(0)
                case .none, .roundedRect:
                    return CGFloat(5)
                }
            }()
        }
    }
    override public var backgroundColor: UIColor? {
        didSet {
            if let backgroundColor = backgroundColor {
                syLayer.setBackgroundColor(backgroundColor)
                originalBackgroundColor = backgroundColor
            }
        }
    }
    
    public var isAnimating = false
    
    public var animationTimingFunction: SYMediaTimingFunction = .linear {
        didSet {
            syLayer.setTimingFunction(animationTimingFunction)
        }
    }
    
    public var animationType: AnimationType = .border {
        didSet {
            syLayer.animationType = {
                switch animationType {
                case .border:
                    return .border
                case .borderWithShadow:
                    return .borderWithShadow
                case .background:
                    return .background
                case .ripple:
                    return .ripple
                }
            }()
        }
    }
    
    fileprivate var originalBackgroundColor: UIColor = .white
    
    fileprivate lazy var syLayer: SYLayer = .init(layer: self.layer)
    
    // MARK: - initializer -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Public Methods -
    
    public func startAnimating() {
        isAnimating = true
        if case (.background, .roundedRect) = (animationType, borderStyle) {
            backgroundColor = .clear
        }
        syLayer.startAnimating()
    }
    
    public func stopAnimating() {
        isAnimating = false
        if case (.background, .roundedRect) = (animationType, borderStyle) {
            backgroundColor = originalBackgroundColor
        }
        syLayer.stopAnimating()
    }
    
    // MARK: - Private Methods -
    
    private func configure() {
        syLayer.animationType = .border
        borderStyle = .roundedRect
    }
}
