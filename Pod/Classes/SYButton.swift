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
    
    public var buttonColor: UIColor = UIColor() {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.syLayer.backgroundColor = buttonColor
        }
    }
    
    public var animationBorderColor = UIColor() {
        didSet {
            self.syLayer.animationBorderColor = self.animationBorderColor
        }
    }
    
    public var animationBackgroundColor = UIColor() {
        didSet {
            self.syLayer.animationBackgroundColor = self.animationBackgroundColor
        }
    }
    
    public var animationTextColor = UIColor() {
        didSet {
            self.syLayer.animationTextColor = self.animationTextColor
        }
    }
    
    public var animationRippleColor = UIColor() {
        didSet {
            self.syLayer.animationRippleColor = self.animationRippleColor
        }
    }
    
    public var textColor = UIColor()
    
    public var isAnimating = false
    
    private var isFirstSetTextLayer = false
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        
        !self.isFirstSetTextLayer ? self.firstSetTextLayer() : self.resetTextLayer()
    }
    
    override public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(UIColor.clearColor(), forState: state)
        
        self.textLayer.foregroundColor = color?.CGColor
        self.syLayer.textColor = color!
        self.textColor = color!
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
        
        self.syLayer.syLayerAnimation = .Border
        
        self.animationBorderColor = UIColor(red: 210/255.0, green: 77/255.0, blue: 87/255.0, alpha: 1)
        self.animationBackgroundColor = UIColor(red: 89/255.0, green: 171/255.0, blue: 227/255.0, alpha: 1)
        self.buttonColor = UIColor.clearColor()
        self.animationTextColor = UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 1)
        self.animationRippleColor = UIColor(red: 65/255.0, green: 131/255.0, blue: 215/255.0, alpha: 1)
        
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    private func setTextLayer() {
        let font = UIFont.systemFontOfSize(17.0)//Fix 文字がずれている模様, size変更に対応
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
    }
    
    private func firstSetTextLayer() {
        self.isFirstSetTextLayer = true
        self.setTextLayer()
        self.syLayer.firstSetTextLayer(self.textLayer)
    }
    
    private func resetTextLayer(){
        self.setTextLayer()
        self.syLayer.resetTextLayer(self.textLayer)
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
