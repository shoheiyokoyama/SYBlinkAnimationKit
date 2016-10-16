//
//  SYView.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/01/16.
//
//

import UIKit

@IBDesignable
public final class SYView: UIView, AnimatableComponent {
    
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
            if let backgroundColor = backgroundColor {
                syLayer.setBackgroundColor(backgroundColor)
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
        syLayer.startAnimating()
    }
    
    public func stopAnimating() {
        isAnimating = false
        syLayer.stopAnimating()
    }
    
    // MARK: - Private Methods -
    
    func configure() {
        animationType = .border
        layer.cornerRadius = 1.5
    }
}
