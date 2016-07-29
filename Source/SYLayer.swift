//
//  SYLayer.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

final class SYLayer: Animatable {
    var superLayer     = CALayer()
    var textLayer      = CATextLayer()
    var rippleLayer    = CALayer()
    var subRippleLayer = CALayer()
    
    var animationDuration: CFTimeInterval = AnimationConstants.defaultDuration
    var animationTimingFunction: SYMediaTimingFunction = .linear
    
    var animationType: AnimationType = .border {
        didSet {
            switch animationType {
            case .border:
                configureBorderAnimation()
            case .borderWithShadow:
                configureBorderWithShadowAnimation()
            default:
                return
            }
        }
    }
    
    var textColor = UIColor.blackColor()
    var backgroundColor = UIColor.whiteColor() {
        didSet {
            superLayer.backgroundColor = backgroundColor.CGColor
        }
    }
    
    var animationBackgroundColor = AnimationDefaultColor.background
    var animationTextColor = AnimationDefaultColor.text
    var animationBorderColor = AnimationDefaultColor.border {
        didSet {
            animationShadowColor = animationBorderColor
        }
    }
    
    var borderColorAnimtion  = CABasicAnimation(type: .borderColor)
    var borderWidthAnimation = CABasicAnimation(type: .borderWidth)
    var shadowAnimation      = CABasicAnimation(type: .shadowOpacity)

    private var animationShadowColor = AnimationDefaultColor.border {
        didSet {
            superLayer.shadowColor = animationShadowColor.CGColor
        }
    }
    private var animationRippleColor = AnimationDefaultColor.ripple {
        didSet {
            rippleLayer.backgroundColor = animationRippleColor.CGColor
            subRippleLayer.borderColor = animationRippleColor.CGColor
        }
    }
    
    private var borderWidth: CGFloat = 0 {
        didSet {
            superLayer.borderWidth = borderWidth
        }
    }
    private var borderColor = UIColor.whiteColor() {
        didSet {
            superLayer.borderColor = borderColor.CGColor
        }
    }
    
    private var shadowRadius: CGFloat = 0 {
        didSet {
            superLayer.shadowRadius = shadowRadius
        }
    }
    private var shadowOpacity: Float = 0 {
        didSet {
            superLayer.shadowOpacity = shadowOpacity
        }
    }
    private var shadowOffset: CGSize = CGSize.zero {
        didSet {
            superLayer.shadowOffset = shadowOffset
        }
    }
    
    // MARK: - initializer -
    
    init(sLayer: CALayer) {
        superLayer = sLayer
        
        setLayer()
    }
    
    // MARK: - Internal Methods -
    
    func setAnimationBorderColor(borderColor: UIColor) {
        animationBorderColor = borderColor
    }
    
    func setAnimationBackgroundColor(backgroundColor: UIColor) {
        animationBackgroundColor = backgroundColor
    }
    
    func setAnimationTextColor(textColor: UIColor) {
        animationTextColor = textColor
    }
    
    func setAnimationRippleColor(rippleColor: UIColor) {
        animationRippleColor = rippleColor
    }

    func setBackgroundColor(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func setTextColor(textColor: UIColor) {
        self.textColor = textColor
    }
    
    func setAnimationTimingFunction(timingFunction: SYMediaTimingFunction) {
        animationTimingFunction = timingFunction
    }
    
    func setAnimationDuration(animationDuration: CFTimeInterval) {
        self.animationDuration = animationDuration
    }
    
    func resizeSuperLayer() {
        resizeRippleLayer()
        resizeTextLayer()
        resizeShadowPath()
    }
    
    func resetTextLayer(textLayer: CATextLayer) {
        self.textLayer = textLayer
        if let sublayers = superLayer.sublayers where sublayers.contains ({ $0 === textLayer }) == false {
            superLayer.insertSublayer(self.textLayer, atIndex: 0)
        }
    }
}

// MARK: - Private Methods -

private extension SYLayer {
    
    private func setLayer() {
        superLayer.shadowColor  = animationShadowColor.CGColor
        superLayer.borderColor  = borderColor.CGColor
        superLayer.borderWidth  = borderWidth
        superLayer.shadowOffset = CGSize.zero
        
        setRippleLayer()
    }
    
    private func setRippleLayer() {
        configureRippleLayer()
        rippleLayer.opacity = 0
        superLayer.addSublayer(rippleLayer)

        subRippleLayer.opacity = 0
        superLayer.insertSublayer(subRippleLayer, atIndex: 1)
    }
    
    private func configureRippleLayer() {
        let height = superLayer.frame.height

        let diameter: CGFloat     = height * AnimationConstants.rippleDiameterRatio
        let cornerRadius: CGFloat = diameter / 2

        rippleLayer.backgroundColor = animationRippleColor.CGColor
        rippleLayer.cornerRadius    = cornerRadius
        rippleLayer.frame           = CGRect(x: (superLayer.bounds.width - diameter) / 2, y: (superLayer.bounds.height - diameter) / 2, width: diameter, height: diameter)

        let subDiameter: CGFloat     = height * AnimationConstants.subRippleDiameterRatio
        let subCornerRadius: CGFloat = subDiameter / 2

        subRippleLayer.borderColor     = animationRippleColor.CGColor
        subRippleLayer.borderWidth     = AnimationConstants.borderWidth
        subRippleLayer.backgroundColor = UIColor.clearColor().CGColor
        subRippleLayer.cornerRadius    = subCornerRadius
        subRippleLayer.frame           = CGRect(x: (superLayer.bounds.width - subDiameter) / 2, y: (superLayer.bounds.height - subDiameter) / 2, width: subDiameter, height: subDiameter)
    }
    
    private func resizeRippleLayer() {
        configureRippleLayer()
    }
    
    private func resizeTextLayer() {
        let superLayerHeight = superLayer.frame.height
        let superLayerWidth  = superLayer.frame.width

        textLayer.frame.origin.x = (superLayerWidth - textLayer.frame.width) / 2
        textLayer.frame.origin.y = (superLayerHeight - textLayer.frame.height) / 2
    }
    
    private func resizeShadowPath() {
        resetSuperLayerShadow()
    }
}
