//
//  SYLayer.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

enum SYLayerAnimation {
    case Border
    case BorderWithShadow
    case Background
    case Ripple
    case Text
}

public enum SYMediaTimingFunction: Int {
    case Linear
    case EaseIn
    case EaseOut
    case EaseInEaseOut
    
    private var timingFunction : CAMediaTimingFunction {
        switch self {
        case .Linear:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .EaseIn:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .EaseOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .EaseInEaseOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
    }
}

final class SYLayer {
    
    private var superLayer: CALayer!
    
    private var textLayer      = CATextLayer()
    private var rippleLayer    = CALayer()
    private var subRippleLayer = CALayer()
    
    private var borderColorAnimtion  = CABasicAnimation(keyPath: AnimationKeyType.borderColor.keyPath)
    private var borderWidthAnimation = CABasicAnimation(keyPath: AnimationKeyType.borderWidth.keyPath)
    private var shadowAnimation      = CABasicAnimation(keyPath: AnimationKeyType.shadowOpacity.keyPath)
    
    private var animationBorderColor = AnimationDefaultColor.border {
        didSet {
            animationShadowColor = animationBorderColor
        }
    }
    private var animationTextColor = AnimationDefaultColor.text
    private var animationBackgroundColor = AnimationDefaultColor.background
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
    
    private var animationDuration: CFTimeInterval = AnimationConstants.defaultDuration
    private var animationTimingFunction: SYMediaTimingFunction = .Linear
    
    private var textColor = UIColor.blackColor()
    private var backgroundColor = UIColor.whiteColor() {
        didSet {
            superLayer.backgroundColor = backgroundColor.CGColor
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
    
    var syLayerAnimation: SYLayerAnimation = .Border {
        didSet {
            switch syLayerAnimation {
            case .Border:
                configureBorderAnimation()
            case .BorderWithShadow:
                configureBorderWithShadowAnimation()
            default:
                return
            }
        }
    }
    
    func startAnimation() {
        switch syLayerAnimation {
        case .Border:
            animateBorderOrBorderWithShadow()
        case .BorderWithShadow:
            animateBorderOrBorderWithShadow()
        case .Background:
            animateBackground()
        case .Text:
            animateText()
        case .Ripple:
            animateRipple()
        }
    }
    
    func stopAnimation() {
        superLayer.removeAllAnimations()
        textLayer.removeAllAnimations()
        subRippleLayer.removeAllAnimations()
        rippleLayer.removeAllAnimations()

        textLayer.foregroundColor = textColor.CGColor
    }
}

// MARK: - Private Methods -

private extension SYLayer {
    
    private struct AnimationConstants {
        static let borderWidth: CGFloat            = 1
        static let defaultDuration: CFTimeInterval = 1.5
        static let rippleDiameterRatio: CGFloat    = 0.7
        static let subRippleDiameterRatio: CGFloat = 0.85
        static let shadowRadiusIfNotClear: CGFloat = 4
        static let shadowRadius: CGFloat           = 2.5
        static let shadowOpacity: CGFloat          = 0.5
        static let repeatCount: Float              = 1e100
        static let fromTextColorAlpha: CGFloat     = 0.15
        static let rippleToAlpha: CGFloat          = 0
        static let rippleToScale: CGFloat          = 1
    }
    
    private enum AnimationKeyType: String {
        case borderColor
        case borderWidth
        case shadowOpacity
        case backgroundColor
        case foregroundColor
        case opacity
        case transformScale  = "transform.scale"
        
        private var keyPath: String {
            get {
                return rawValue
            }
        }
        
        private var fromValue: AnyObject {
            switch self {
            case .borderColor:
                return UIColor.clearColor().CGColor
            case .borderWidth:
                return 0
            case .shadowOpacity:
                return 0
            case .backgroundColor:
                return UIColor.clearColor().CGColor
            case .foregroundColor:
                //Don't use
                return UIColor.clearColor().CGColor
            case .opacity:
                return 1
            case .transformScale:
                return 0.4
            }
        }
    }
    
    private func setLayer() {
        superLayer.shadowColor  = animationShadowColor.CGColor
        superLayer.borderColor  = borderColor.CGColor
        superLayer.borderWidth  = borderWidth
        superLayer.shadowOffset = CGSize.zero
        
        setRippleLayer()
    }
    
    private func setRippleLayer() {
        setRippleLayerPosition()
        rippleLayer.opacity = 0
        superLayer.addSublayer(rippleLayer)

        subRippleLayer.opacity = 0
        superLayer.insertSublayer(subRippleLayer, atIndex: 1)
    }
    
    private func setRippleLayerPosition() {
        let superLayerHeight = superLayer.frame.height

        let rippleDiameter: CGFloat     = superLayerHeight * AnimationConstants.rippleDiameterRatio
        let rippleCornerRadius: CGFloat = rippleDiameter / 2

        rippleLayer.backgroundColor = animationRippleColor.CGColor
        rippleLayer.cornerRadius    = rippleCornerRadius
        rippleLayer.frame           = CGRect(x: (superLayer.bounds.width - rippleDiameter) / 2, y: (superLayer.bounds.height - rippleDiameter) / 2, width: rippleDiameter, height: rippleDiameter)

        let subRippleDiameter: CGFloat     = superLayerHeight * AnimationConstants.subRippleDiameterRatio
        let subRippleCornerRadius: CGFloat = subRippleDiameter / 2

        subRippleLayer.borderColor     = animationRippleColor.CGColor
        subRippleLayer.borderWidth     = AnimationConstants.borderWidth
        subRippleLayer.backgroundColor = UIColor.clearColor().CGColor
        subRippleLayer.cornerRadius    = subRippleCornerRadius
        subRippleLayer.frame           = CGRect(x: (superLayer.bounds.width - subRippleDiameter) / 2, y: (superLayer.bounds.height - subRippleDiameter) / 2, width: subRippleDiameter, height: subRippleDiameter)
    }
    
    private func resetSuperLayerShadow() {
        if CGColorGetAlpha(backgroundColor.CGColor) == 1 {
            superLayer.shadowPath   = UIBezierPath(rect: superLayer.bounds).CGPath
            superLayer.shadowRadius = AnimationConstants.shadowRadiusIfNotClear
            return
        }
        
        let bw: CGFloat  = AnimationConstants.borderWidth * 2
        let bwh: CGFloat = bw / 2
        let sw           = superLayer.frame.width
        let sh           = superLayer.frame.height
        let c            = superLayer.cornerRadius

        let pathRef: CGMutablePathRef = CGPathCreateMutable()

        CGPathMoveToPoint(pathRef, nil, -bwh, -bwh + c)

        CGPathAddArcToPoint(pathRef , nil, -bwh        , -bwh, -bwh + c, -bwh  , c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh - c, -bwh)
        CGPathAddArcToPoint(pathRef , nil, sw+bwh      , -bwh, sw + bwh, -bwh+c, c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh, bwh + c)
        CGPathAddArcToPoint(pathRef , nil, sw - bwh, bwh, sw - bwh - c, bwh, c)

        CGPathAddLineToPoint(pathRef, nil, bwh + c, bwh)
        CGPathAddArcToPoint(pathRef , nil, bwh    , bwh, bwh, bwh + c, c)

        CGPathAddLineToPoint(pathRef, nil, bwh, sh - bwh - c)
        CGPathAddArcToPoint(pathRef , nil, bwh, sh - bwh, bwh + c, sh - bwh, c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh - c, sh - bwh)
        CGPathAddArcToPoint(pathRef , nil, sw - bwh    , sh - bwh, sw - bwh, sh - bwh - c, c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh, bwh + c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh, -bwh + c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh, sh + bwh - c)
        CGPathAddArcToPoint(pathRef , nil, sw + bwh, sh + bwh    , sw + bwh - c, sh + bwh, c)

        CGPathAddLineToPoint(pathRef, nil, -bwh + c, sh + bwh)
        CGPathAddArcToPoint(pathRef , nil, -bwh    , sh + bwh, -bwh, sh + bwh - c, c)

        CGPathAddLineToPoint(pathRef, nil, -bwh, -bwh + c)

        CGPathCloseSubpath(pathRef)
        
        superLayer.shadowPath   = pathRef
        superLayer.shadowRadius = AnimationConstants.shadowRadius
    }
    
    private func resizeRippleLayer() {
        setRippleLayerPosition()
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
    
    private func configureBorderAnimation() {
        configureBorderColorAnimation()
        configureBorderWidthAnimation()
    }
    
    private func configureBorderWithShadowAnimation() {
        configureBorderColorAnimation()
        configureShadowAnimation()
        configureBorderWidthAnimation()
    }
    
    private func configureBorderColorAnimation() {
        borderColorAnimtion.fromValue = AnimationKeyType.borderColor.fromValue
        borderColorAnimtion.toValue   = animationBorderColor.CGColor
    }
    
    private func configureBorderWidthAnimation() {
        borderWidthAnimation.fromValue = AnimationKeyType.borderWidth.fromValue
        borderWidthAnimation.toValue   = AnimationConstants.borderWidth
    }
    
    private func configureShadowAnimation() {
        shadowAnimation.fromValue = AnimationKeyType.shadowOpacity.fromValue
        shadowAnimation.toValue   = AnimationConstants.shadowOpacity
    }
    
    private func animateBorderOrBorderWithShadow() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration       = animationDuration
        groupAnimation.animations     = [borderColorAnimtion, borderWidthAnimation]
        groupAnimation.timingFunction = animationTimingFunction.timingFunction
        groupAnimation.delegate       = self
        groupAnimation.autoreverses   = true
        groupAnimation.repeatCount    = AnimationConstants.repeatCount
        syLayerAnimation == .BorderWithShadow ? animateBorderWithShadow(groupAnimation) : superLayer.addAnimation(groupAnimation, forKey: nil)
    }

    private func animateBorderWithShadow(groupAnimation: CAAnimationGroup) {
        resetSuperLayerShadow()
        
        superLayer.masksToBounds   = false
        superLayer.backgroundColor = backgroundColor.CGColor
        groupAnimation.animations?.append(shadowAnimation)
        superLayer.addAnimation(groupAnimation, forKey: nil)
    }
    
    private func animateBackground() {
        let type: AnimationKeyType = .backgroundColor
        let backgroundColorAnimation = CABasicAnimation(keyPath: type.keyPath)
        backgroundColorAnimation.fromValue      = type.fromValue
        backgroundColorAnimation.toValue        = animationBackgroundColor.CGColor
        backgroundColorAnimation.duration       = animationDuration
        backgroundColorAnimation.autoreverses   = true
        backgroundColorAnimation.repeatCount    = AnimationConstants.repeatCount
        backgroundColorAnimation.timingFunction = animationTimingFunction.timingFunction
        superLayer.addAnimation(backgroundColorAnimation, forKey: nil)
    }
    
    private func animateText() {
        let textColorAnimation = CABasicAnimation(keyPath: AnimationKeyType.foregroundColor.keyPath)
        textColorAnimation.duration            = animationDuration
        textColorAnimation.autoreverses        = true
        textColorAnimation.repeatCount         = AnimationConstants.repeatCount
        textColorAnimation.removedOnCompletion = false
        textColorAnimation.timingFunction      = animationTimingFunction.timingFunction
        textColorAnimation.fromValue           = animationTextColor.colorWithAlphaComponent(AnimationConstants.fromTextColorAlpha).CGColor
        textColorAnimation.toValue             = animationTextColor.CGColor
        
        textLayer.foregroundColor = animationTextColor.CGColor
        textLayer.addAnimation(textColorAnimation, forKey: nil)
    }
    
    private func animateRipple() {
        let opacityType: AnimationKeyType = .opacity
        let fadeOutOpacity = CABasicAnimation(keyPath: opacityType.keyPath)
        fadeOutOpacity.fromValue = opacityType.fromValue
        fadeOutOpacity.toValue   = AnimationConstants.rippleToAlpha

        let scaleType: AnimationKeyType = .transformScale
        let scale = CABasicAnimation(keyPath: scaleType.keyPath)
        scale.fromValue = scaleType.fromValue
        scale.toValue   = AnimationConstants.rippleToScale

        let animationGroup = CAAnimationGroup()
        animationGroup.duration       = animationDuration
        animationGroup.repeatCount    = AnimationConstants.repeatCount
        animationGroup.timingFunction = animationTimingFunction.timingFunction
        animationGroup.animations     = [fadeOutOpacity, scale]

        rippleLayer.addAnimation(animationGroup, forKey: nil)
        subRippleLayer.addAnimation(animationGroup, forKey: nil)
    }
}
