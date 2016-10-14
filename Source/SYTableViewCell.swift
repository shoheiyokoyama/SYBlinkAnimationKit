//
//  SYTableViewCell.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/29.
//
//

import UIKit

@IBDesignable
open class SYTableViewCell: UITableViewCell, AnimatableComponent {
    
    public enum AnimationType: Int {
        case border, borderWithShadow, background, ripple
    }
    
    @IBInspectable open var animationBorderColor: UIColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable open var animationBackgroundColor: UIColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable open var animationRippleColor: UIColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
        }
    }
    @IBInspectable open var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .linear
        }
    }
    @IBInspectable open var animationDuration: CGFloat = 1 {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    @IBInspectable open  var animationAdapter: Int {
        get {
            return animationType.rawValue
        }
        set(index) {
            animationType = AnimationType(rawValue: index) ?? .border
        }
    }
    
    open var isAnimating = false
    
    open var animationTimingFunction: SYMediaTimingFunction = .linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    open var animationType: AnimationType = .border {
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
    
    fileprivate lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    fileprivate let cornerRadius: CGFloat = 1.1
    
    // MARK: - initializer -
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setLayer()
    }
    
    // MARK: - Public Methods -
    
    open func startAnimation() {
        isAnimating = true
        syLayer.startAnimation()
    }
    
    open func stopAnimation() {
        isAnimating = false
        syLayer.stopAnimation()
    }
    
    // MARK: - Fileprivate Methods -
    
    fileprivate func setLayer() {
        layer.cornerRadius = cornerRadius
    }
}
