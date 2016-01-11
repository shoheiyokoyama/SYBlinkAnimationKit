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

public class SYTextField: UITextField {

    @IBInspectable public var animationBorderColor:UIColor = UIColor() {
        didSet {
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    @IBInspectable public var animationRippleColor:UIColor = UIColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    @IBInspectable public var animationBackgroundColor:UIColor = UIColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    
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
    
    public var isAnimating = false
    
    @IBInspectable public var stopAnimationWithTouch = true
    
    private var originalBackgroundColor = UIColor.clearColor()
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            self.syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    
    @IBInspectable public var animationDuration: CGFloat = 1.0 {
        didSet {
            self.syLayer.setAnimationDuration(CFTimeInterval(animationDuration))
        }
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if self.stopAnimationWithTouch && isAnimating {
            self.stopAnimation()
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override public var borderStyle: UITextBorderStyle {
        didSet {
            switch borderStyle {
            case .Bezel:
                self.layer.cornerRadius = 0.0
            case .Line:
                self.layer.cornerRadius = 0.0
            case .None:
                self.layer.cornerRadius = 5.0
            case .RoundedRect:
                self.layer.cornerRadius = 5.0
            }
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard backgroundColor == nil else {
                self.syLayer.backgroundColor = backgroundColor!
                self.originalBackgroundColor = backgroundColor!
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
    
    public func startAnimation() {
        self.isAnimating = true
        if self.syTextFieldAnimation == .Background &&  self.borderStyle == .RoundedRect {
            self.backgroundColor = UIColor.clearColor()
        }
        
        self.syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        self.isAnimating = false
        if self.syTextFieldAnimation == .Background &&  self.borderStyle == .RoundedRect {
            self.backgroundColor = originalBackgroundColor
        }
        self.syLayer.stopAnimation()
    }
}

private extension SYTextField {
    
    private func setLayer() {
        self.syLayer.syLayerAnimation = .Border
        
        self.borderStyle = .RoundedRect
    }
}
