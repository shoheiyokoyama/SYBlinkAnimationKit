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
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    @IBInspectable public var animationBackgroundColor: UIColor = UIColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    @IBInspectable public var animationTextColor: UIColor = UIColor() {
        didSet {
            self.syLayer.animationTextColor = self.animationTextColor
        }
    }
    @IBInspectable public var animationRippleColor: UIColor = UIColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    
    public var isAnimating = false
    
    override public var frame: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer()
        }
    }
    override public var bounds: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer()
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard backgroundColor == nil else {
                self.syLayer.backgroundColor = backgroundColor!
                return
            }
        }
    }
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            self.syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
        get {
            return self.animationTimingFunction.rawValue
        }
        set(index) {
            self.animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .Linear
        }
    }
    
    @IBInspectable public var animationDuration: CGFloat = 1.0 {
        didSet {
            self.syLayer.setAnimationDuration(CFTimeInterval(animationDuration))
        }
    }
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setLayer()
    }
    
    public var syViewAnimation: SYViewAnimation = .Border {
        didSet {
            switch syViewAnimation {
            case .Border:
                self.syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                self.syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                self.syLayer.syLayerAnimation = .Background
            case .Ripple:
                self.syLayer.syLayerAnimation = .Ripple
            }
        }
    }
    @IBInspectable public  var syViewAnimationAdapter: Int {
        get {
            return self.syViewAnimation.rawValue
        }
        set(index) {
            self.syViewAnimation = SYViewAnimation(rawValue: index) ?? .Border
        }
    }
    
    public func startAnimation() {
        self.isAnimating = true
        self.syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        self.isAnimating = false
        self.syLayer.stopAnimation()
    }
}

private extension SYView {
    
    private func setLayer() {
        self.syViewAnimation = .Border
        self.layer.cornerRadius = 1.5
    }
}
