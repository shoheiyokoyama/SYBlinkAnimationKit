//
//  SYTextField.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYTextFieldAnimation {
    case Border
    case BorderWithShadow
    case Background
    case Ripple
}

public enum SYBorderStyle {
    case RoundedRect
    case None
}

public class SYTextField: UITextField {

    public var animationBorderColor = UIColor() {
        didSet {
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    
    public var animationRippleColor = UIColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    
    public var animationBackgroundColor = UIColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    
    override public var frame: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer()
        }
    }
    
    public var isAnimating = false
    
    public var stopAnimationWithTouch = true
    
    private var oldSyBorderStyle = SYBorderStyle.RoundedRect
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            self.syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    public var animationDuration: CFTimeInterval = 1.0 {
        didSet {
            self.syLayer.setAnimationDuration(animationDuration)
        }
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if self.stopAnimationWithTouch && isAnimating {
            self.stopAnimation()
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard backgroundColor == nil else {
                self.syLayer.backgroundColor = backgroundColor!
                return
            }
        }
    }
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setLayer() {
        self.layer.cornerRadius = 5.0 //Fix
        
        self.syLayer.syLayerAnimation = .Border
        
        self.syBorderStyle = .RoundedRect//この時に背景色がアニメーションしない！
        
        self.layer.masksToBounds = false
    }
    
    public var syTextFieldAnimation: SYTextFieldAnimation = .Border {
        didSet {
            switch syTextFieldAnimation {
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
    
    public var syBorderStyle: SYBorderStyle = .RoundedRect {
        didSet {
            switch syBorderStyle {
            case .RoundedRect:
                self.borderStyle = .RoundedRect
                self.oldSyBorderStyle = .RoundedRect
            case .None:
                self.layer.backgroundColor = UIColor.whiteColor().CGColor//?
                self.borderStyle = .None
                self.oldSyBorderStyle = .None
            }
        }
    }
    
    public func startAnimation() {
        self.isAnimating = true
        if self.syTextFieldAnimation == .Background {
            self.borderStyle = .None
        }
        self.syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        self.isAnimating = false
        if self.syTextFieldAnimation == .Background {
            self.syBorderStyle = self.oldSyBorderStyle
        }
        self.syLayer.stopAnimation()
    }
}
