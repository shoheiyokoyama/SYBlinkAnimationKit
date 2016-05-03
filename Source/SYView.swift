//
//  SYView.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/01/16.
//
//

import UIKit

public enum SYViewAnimation: Int {
    case Border = 0
    case BorderWithShadow
    case Background
    case Ripple
}

public class SYView: UIView, Animatable {
    
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
    
    public var isAnimating = false
    
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
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
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
    
    public var syViewAnimation: SYViewAnimation = .Border {
        didSet {
            switch syViewAnimation {
            case .Border:
                syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                syLayer.syLayerAnimation = .Background
            case .Ripple:
                syLayer.syLayerAnimation = .Ripple
            }
        }
    }
    @IBInspectable public  var syViewAnimationAdapter: Int {
        get {
            return syViewAnimation.rawValue
        }
        set(index) {
            syViewAnimation = SYViewAnimation(rawValue: index) ?? .Border
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

private extension SYView {
    
    private func setLayer() {
        syViewAnimation = .Border
        layer.cornerRadius = 1.5
    }
}
