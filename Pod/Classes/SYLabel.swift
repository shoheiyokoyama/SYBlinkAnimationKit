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
    case BorderWithLight
    case Background
    case Text
    case Ripple
}

public class SYLabel: UILabel {

    private let textLayer = CATextLayer()
    
    public var labelColor: UIColor = UIColor.clearColor() {
        didSet {
            self.backgroundColor = UIColor.clearColor()
            self.syLayer.backgroundColor = labelColor
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
            case .BorderWithLight:
                self.syLayer.syLayerAnimation = .BorderWithLight
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
