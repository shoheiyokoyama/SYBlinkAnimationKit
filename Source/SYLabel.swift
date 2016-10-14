//
//  SYLabel.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

@IBDesignable
public class SYLabel: UILabel, AnimatableComponent, TextConvertible {
    
    public enum AnimationType: Int {
        case border, borderWithShadow, background, ripple, text
    }
    
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
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .linear
        }
    }
    @IBInspectable public var animationDuration: CGFloat = LabelConstants.defaultDuration {
        didSet {
            syLayer.setAnimationDuration(CFTimeInterval(animationDuration))
        }
    }
    @IBInspectable public var labelTextColor: UIColor = UIColor.black {
        didSet {
            textColor = UIColor.clear
            textLayer.foregroundColor = labelTextColor.cgColor
            syLayer.setTextColor(labelTextColor)
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
            resetTextLayer()
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
    
    public var isAnimating = false
    
    var textLayer = CATextLayer()
    public var textAlignmentMode: TextAlignmentMode = .center {
        didSet {
            resetTextLayer()
        }
    }
    
    public var animationTimingFunction: SYMediaTimingFunction = .linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    fileprivate lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
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
    
    public func setFontOfSize(_ fontSize: CGFloat) {
        font = UIFont.systemFont(ofSize: fontSize)
        resetTextLayer()
    }
    
    public func setFontNameWithSize(_ name: String, size: CGFloat) {
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

// MARK: - Fileprivate Methods -

fileprivate extension SYLabel {
    
    struct LabelConstants {
        static let cornerRadius: CGFloat    = 1.5
        static let defaultDuration: CGFloat = 1
    }
    
    func setLayer() {
        layer.cornerRadius = LabelConstants.cornerRadius
        
        textColor      = UIColor.clear
        labelTextColor = UIColor.black
        
        syLayer.animationType = .border
    }
    
    func resetTextLayer() {
        configureTextLayer(text, font: font, textColor: labelTextColor)
        syLayer.resetTextLayer(textLayer)
    }
}
