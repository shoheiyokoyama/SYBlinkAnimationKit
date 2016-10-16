//
//  SYButton.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

@IBDesignable
public class SYButton: UIButton, AnimatableComponent, TextConvertible {
    public enum AnimationType: Int {
        case border, borderWithShadow, background, ripple, text
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
    @IBInspectable public var animationTextColor = AnimationDefaultColor.text {
        didSet {
            syLayer.setAnimationTextColor(animationTextColor)
        }
    }
    @IBInspectable public var animationRippleColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setRippleColor(animationRippleColor)
        }
    }
    @IBInspectable var animationTimingAdapter: Int {
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
    @IBInspectable var animationAdapter: Int {
        get {
            return animationType.rawValue
        }
        set(index) {
            animationType = AnimationType(rawValue: index) ?? .border
        }
    }
    
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
                case .text:
                    return .text
                }
            }()
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
            if let backgroundColor = backgroundColor {
                syLayer.setBackgroundColor(backgroundColor)
            }
        }
    }
    
    public var isAnimating = false
    
    var textLayer = CATextLayer()
    
    public var textAlignmentMode: TextAlignmentMode = .center {
        didSet {
            resetTextLayer()
        }
    }
    
    fileprivate lazy var syLayer: SYLayer = .init(layer: self.layer)
    
    fileprivate var textColor: UIColor = .black {
        didSet {
            syLayer.setTextColor(textColor)
        }
    }
    
    // MARK: - initializer -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Override Methods -
    
    override public func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title ?? "", for: state)
        resetTextLayer()
    }
    
    override public func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(UIColor.clear, for: state)
        
        if let color = color {
            textLayer.foregroundColor = color.cgColor
            textColor = color
        }
    }
    
    // MARK: - Public Methods -
    
    public func setFont(name fontName: String = ".SFUIText-Medium", ofSize fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont(name: fontName, size: fontSize)
        resetTextLayer()
        return self
    }
    
    public func startAnimating() {
        isAnimating = true
        syLayer.startAnimating()
    }
    
    public func stopAnimating() {
        isAnimating = false
        syLayer.startAnimating()

    }
}

// MARK: - Fileprivate Methods -

fileprivate extension SYButton {
    func configure() {
        layer.cornerRadius = 5
        
        let padding: CGFloat = 5
        contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        syLayer.animationType = .border
        
        setTitleColor(.black, for: .normal)
    }
    
    func resetTextLayer() {
        configureTextLayer(currentTitle, font: titleLabel?.font, textColor: textColor)
        syLayer.resetTextLayer(textLayer)
    }
}
