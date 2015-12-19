//
//  SYLabel.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYLabelAnimation {
    case Border
    case BorderWithShadow
    case Background
    case Text
    case Ripple
}

public class SYLabel: UILabel {

    private let textLayer = CATextLayer()
    
    public var labelColor: UIColor = UIColor() {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.syLayer.backgroundColor = labelColor
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
    
    override public var frame: CGRect {
        didSet {
            self.syLayer.resizeSuperLayer(self.frame)
        }
    }
    
    override public var text: String? {
        didSet {
            self.textLayer.string = text
            self.setTextLayer(text!)
        }
    }
    
    public var isAnimating = false
    
    public lazy var syLayer: SYLayer = SYLayer(superLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setLayer() {
        self.textColor = UIColor.clearColor()
        self.syLayer.syLayerAnimation = .Border // Default Animation
        
        self.labelColor = UIColor.clearColor()
        self.animationBorderColor = UIColor(red: 210/255.0, green: 77/255.0, blue: 87/255.0, alpha: 1)
        self.animationBackgroundColor = UIColor(red: 89/255.0, green: 171/255.0, blue: 227/255.0, alpha: 1)
        self.animationTextColor = UIColor(red: 189/255.0, green: 195/255.0, blue: 199/255.0, alpha: 1)
        self.animationRippleColor = UIColor(red: 65/255.0, green: 131/255.0, blue: 215/255.0, alpha: 1)
        
    }
    
    private func setTextLayer(text: String) {
        let font = UIFont.systemFontOfSize(17.0)
        let text = text
        
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        let size = text.sizeWithAttributes(attributes)
        
        let x = (CGRectGetWidth(self.frame) - size.width) / 2
        let y = (CGRectGetHeight(self.frame) - size.height) / 2
        let height = size.height + self.layer.borderWidth
        let width = size.width
        let frame = CGRectMake(x, y, width, height)
        
        self.textLayer.font = self.font
        self.textLayer.string = text
        self.textLayer.fontSize = font.pointSize
        
        self.textLayer.foregroundColor = UIColor.blackColor().CGColor
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        
        self.textLayer.frame = frame
        self.textLayer.alignmentMode = kCAAlignmentCenter
        
        self.syLayer.setTextLayer(textLayer)
    }
    
    public var syLabelAnimation: SYLabelAnimation = .Border {
        didSet {
            switch syLabelAnimation {
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
