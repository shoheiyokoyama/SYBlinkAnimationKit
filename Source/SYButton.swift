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

@IBDesignable public class SYButton: UIButton {
    
    private let textLayer = CATextLayer()
    
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

    private var textColor = UIColor.blackColor() {
        didSet {
            self.syLayer.textColor = textColor
        }
    }
    
    public var isAnimating = false
    
    private var isFirstSetTextLayer = false
    
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
    
    override public func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        
        guard title == nil else {
            !self.isFirstSetTextLayer ? self.firstSetTextLayer() : self.resetTextLayer()
            return
        }
    }
    override public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(UIColor.clearColor(), forState: state)
        
        guard color == nil else {
            self.textLayer.foregroundColor = color?.CGColor
            self.textColor = color!
            return
        }
    }
    
    public func setFontOfSize(fontSize: CGFloat) {
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        self.resetTextLayer()
    }
    public func setFontNameWithSize(name: String, size: CGFloat) {
        self.titleLabel!.font = UIFont(name: name, size: size)
        self.resetTextLayer()
    }
    
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
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

private extension SYButton {
    
    private func setLayer() {
        self.layer.cornerRadius = 5.0
        
        self.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        self.syLayer.syLayerAnimation = .Border
        
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    private func setTextLayer() {
        let font = self.titleLabel?.font
        let text = self.currentTitle
        
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let size = text!.sizeWithAttributes(attributes)
        
        let x = (CGRectGetWidth(self.frame) - size.width) / 2
        let y = (CGRectGetHeight(self.frame) - size.height) / 2
        let height = size.height + self.layer.borderWidth
        let width = size.width
        let frame = CGRectMake(x, y, width, height)
        
        self.textLayer.font = font
        self.textLayer.string = text
        self.textLayer.fontSize = font!.pointSize
        
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
}
