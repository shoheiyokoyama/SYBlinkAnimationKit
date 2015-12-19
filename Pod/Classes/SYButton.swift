//
//  SYButton.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYButtonAnimation {
    case Border
    case BorderWithShadow
    case Background
    case Text
    case Ripple
}

public class SYButton: UIButton {
    
    private let textLayer = CATextLayer()
    
    public var buttonColor: UIColor = UIColor.clearColor() {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.syLayer.backgroundColor = buttonColor
        }
    }
    
    public var animationBorderColor = UIColor.blackColor() {
        didSet {
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    
    public var animationBackgroundColor = UIColor.blackColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    
    public var animationTextColor = UIColor.blackColor() {
        didSet {
            self.syLayer.animationTextColor = self.animationTextColor
        }
    }
    
    public var animationRippleColor = UIColor.blackColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    
    public var textColor = UIColor()
    
    public var isAnimating = false
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        
        self.setTitleColor(UIColor.clearColor(), forState: state)
        self.setTextLayer()
    }
    
    override public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(UIColor.clearColor(), forState: state)
        
        self.textLayer.foregroundColor = color?.CGColor
        self.syLayer.textColor = color!
        self.textColor = color!
    }
    
    override public var frame: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer(self.frame)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayer() {
        self.layer.cornerRadius = 5.0
        self.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        self.textColor = UIColor.blackColor()
        
        self.syLayer.syLayerAnimation = .Border // Default Animation
    }
    
    private func setTextLayer() {
        let font = UIFont.systemFontOfSize(17.0)
        let text = self.currentTitle
        
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let size = text!.sizeWithAttributes(attributes)
        
        let x = (CGRectGetWidth(self.frame) - size.width) / 2
        let y = (CGRectGetHeight(self.frame) - size.height) / 2
        let height = size.height + self.layer.borderWidth
        let width = size.width
        let frame = CGRectMake(x, y, width, height)
        
        self.textLayer.font = self.titleLabel?.font
        self.textLayer.string = text
        self.textLayer.fontSize = font.pointSize
        
        self.textLayer.foregroundColor = self.textColor.CGColor
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        
        self.textLayer.frame = frame
        self.textLayer.alignmentMode = kCAAlignmentCenter
        
        self.syLayer.setTextLayer(textLayer)
    }
    
    public var syButtonAnimation: SYButtonAnimation = .Border {
        didSet {
            switch syButtonAnimation {
            case .Border:
                self.syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                self.syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                self.syLayer.syLayerAnimation = .Background
            case .Text:
                self.syLayer.syLayerAnimation = .Text
            case .Ripple:
                self.syLayer.syLayerAnimation = .Ripple
            }
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
