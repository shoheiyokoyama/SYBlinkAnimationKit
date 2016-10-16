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
    
    @IBInspectable open var animationBorderColor = AnimationDefaultColor.border {
        didSet {
            syLayer.setBorderColor(animationBorderColor)
        }
    }
    @IBInspectable open var animationBackgroundColor = AnimationDefaultColor.background {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable open var animationRippleColor = AnimationDefaultColor.ripple {
        didSet {
            syLayer.setRippleColor(animationRippleColor)
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
    @IBInspectable open var animationDuration: CGFloat = 1.5 {
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
            syLayer.setTimingFunction(animationTimingFunction)
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
    
    fileprivate lazy var syLayer: SYLayer = .init(layer: self.layer)
    
    // MARK: - initializer -
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Public Methods -
    
    open func startAnimating() {
        isAnimating = true
        syLayer.startAnimating()
    }
    
    open func stopAnimating() {
        isAnimating = false
        syLayer.stopAnimating()
    }
    
    // MARK: - Private Methods -
    
    private func configure() {
        layer.cornerRadius = 1.1
    }
}
