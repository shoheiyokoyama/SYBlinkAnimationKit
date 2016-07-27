//
//  SYLayer.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYLayerAnimation {
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
    
    public var timingFunction : CAMediaTimingFunction {
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

public final class SYLayer {
    
    private struct AnimationConstants {
        static let borderWidth: CGFloat = 1
        static let defaultDuration: CFTimeInterval = 1.5
        static let rippleDiameterRatio: CGFloat = 0.7
        static let subRippleDiameterRatio: CGFloat = 0.85
        static let shadowRadiusIfNotClear: CGFloat = 4
        static let shadowRadius: CGFloat = 2.5
        static let shadowOpacity: CGFloat = 0.5
        static let repeatCount: Float = 1e100
        static let fromTextColorAlpha: CGFloat = 0.15
        static let rippleFromScale: CGFloat = 0.4
    }
    
    enum AnimationKeyPath: String {
        case borderColor
        case borderWidth
        case shadowOpacity
        case backgroundColor
        case foregroundColor
        case opacity
        case transformScale  = "transform.scale"
        
        
    }
    
    private var superLayer: CALayer!
    private var textLayer = CATextLayer()
    private var rippleLayer = CALayer()
    private var subRippleLayer = CALayer()
    
    private var borderColorAnimtion = CABasicAnimation()
    private var borderWidthAnimation = CABasicAnimation()
    private var shadowAnimation = CABasicAnimation()
    private var backgroundColorAnimation = CABasicAnimation()
    private var textColorAnimation = CABasicAnimation()
    
    private var animationBorderColor = AnimationDefaultColor.border {
        didSet {
            borderColorAnimtion.toValue = animationBorderColor.CGColor
            animationShadowColor = animationBorderColor
        }
    }
    private var animationTextColor = AnimationDefaultColor.text {
        didSet {
            textColorAnimation.toValue = animationTextColor.CGColor
        }
    }
    private var animationBackgroundColor = AnimationDefaultColor.background {
        didSet {
            backgroundColorAnimation.toValue = animationBackgroundColor.CGColor
        }
    }
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
    private var borderColor = UIColor.clearColor() {
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
    private var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            superLayer.shadowOffset = shadowOffset
        }
    }
    
    // MARK: - initializer -
    
    public init(sLayer: CALayer) {
        superLayer = sLayer
        
        setLayer()
    }
    
    // MARK: - Public Methods -
    
    public func setAnimationBorderColor(borderColor: UIColor) {
        animationBorderColor = borderColor
    }
    
    public func setAnimationBackgroundColor(backgroundColor: UIColor) {
        animationBackgroundColor = backgroundColor
    }
    
    public func setAnimationTextColor(textColor: UIColor) {
        animationTextColor = textColor
    }
    
    public func setAnimationRippleColor(rippleColor: UIColor) {
        animationRippleColor = rippleColor
    }

    public func setBackgroundColor(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    public func setTextColor(textColor: UIColor) {
        self.textColor = textColor
    }
    
    public func setAnimationTimingFunction(timingFunction: SYMediaTimingFunction) {
        animationTimingFunction = timingFunction
    }
    
    public func setAnimationDuration(animationDuration: CFTimeInterval) {
        self.animationDuration = animationDuration
    }
    
    public func resizeSuperLayer() {
        resizeRippleLayer()
        resizeTextLayer()
        resizeShadowPath()
    }
    
    public func firstSetTextLayer(textLayer: CATextLayer) {
        self.textLayer = textLayer
        superLayer.insertSublayer(self.textLayer, atIndex: 0)
    }
    
    public func resetTextLayer(textLayer: CATextLayer) {
        self.textLayer = textLayer
    }
    
    public var syLayerAnimation: SYLayerAnimation = .Border {
        didSet {
            switch syLayerAnimation {
            case .Border:
                setBorderAnimation()
            case .BorderWithShadow:
                setBorderWithShadowAnimation()
            default:
                return
            }
        }
    }
    
    public func startAnimation() {
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
    
    public func stopAnimation() {
        superLayer.removeAllAnimations()
        textLayer.removeAllAnimations()
        subRippleLayer.removeAllAnimations()
        rippleLayer.removeAllAnimations()

        textLayer.foregroundColor = textColor.CGColor
    }
}

// MARK: - Private Methods -

private extension SYLayer {
    
    private func setLayer() {
        superLayer.shadowColor  = animationShadowColor.CGColor
        superLayer.borderColor  = borderColor.CGColor
        superLayer.borderWidth  = borderWidth
        superLayer.shadowOffset = CGSize(width: 0, height: 0)
        
        setRippleLayer()
    }
    
    private func setRippleLayer() {
        setRippleLayerPosition()
        rippleLayer.opacity    = 0
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
        subRippleLayer.borderWidth     = 1
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
    
    private func setBorderAnimation() {
        setBorderColorAnimation()
        setBorderWidthAnimation(0.0, toValue: AnimationConstants.borderWidth)
    }
    
    private func setBorderWithShadowAnimation() {
        setBorderColorAnimation()
        setShadowAnimation(0.0, toValue: AnimationConstants.shadowOpacity)
        setBorderWidthAnimation(0.0, toValue: AnimationConstants.borderWidth)
    }
    
    private func setBorderColorAnimation() {
        borderColorAnimtion = CABasicAnimation(keyPath: AnimationKeyPath.borderColor.rawValue)
        borderColorAnimtion.fromValue = UIColor.clearColor().CGColor
        borderColorAnimtion.toValue   = animationBorderColor.CGColor
    }
    
    private func setBorderWidthAnimation(fromValue: CGFloat, toValue: CGFloat) {
        borderWidthAnimation = CABasicAnimation(keyPath: AnimationKeyPath.borderWidth.rawValue)
        borderWidthAnimation.fromValue = fromValue
        borderWidthAnimation.toValue   = toValue
    }
    
    private func setShadowAnimation(fromValue: CGFloat, toValue: CGFloat) {
        shadowAnimation = CABasicAnimation(keyPath: AnimationKeyPath.shadowOpacity.rawValue)
        shadowAnimation.fromValue = fromValue
        shadowAnimation.toValue   = toValue
    }
    
    private func animateBorderOrBorderWithShadow() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration       = animationDuration
        groupAnimation.animations     = [borderColorAnimtion, borderWidthAnimation]
        groupAnimation.timingFunction = animationTimingFunction.timingFunction
        groupAnimation.delegate       = self
        groupAnimation.autoreverses   = true
        groupAnimation.repeatCount    = AnimationConstants.repeatCount
        syLayerAnimation == .BorderWithShadow ? animateBorderWithShadow(groupAnimation) : superLayer.addAnimation(groupAnimation, forKey: "Border")
    }

    private func animateBorderWithShadow(groupAnimation: CAAnimationGroup) {
        resetSuperLayerShadow()
        
        superLayer.masksToBounds   = false
        superLayer.backgroundColor = backgroundColor.CGColor
        groupAnimation.animations?.append(shadowAnimation)
        superLayer.addAnimation(groupAnimation, forKey: "BorderWithShadow")
    }
    
    private func animateBackground() {
        backgroundColorAnimation = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
        backgroundColorAnimation.fromValue      = UIColor.clearColor().CGColor
        backgroundColorAnimation.toValue        = animationBackgroundColor.CGColor
        backgroundColorAnimation.duration       = animationDuration
        backgroundColorAnimation.autoreverses   = true
        backgroundColorAnimation.repeatCount    = AnimationConstants.repeatCount
        backgroundColorAnimation.timingFunction = animationTimingFunction.timingFunction
        superLayer.addAnimation(backgroundColorAnimation, forKey: "Background")
    }
    
    private func animateText() {
        textColorAnimation = CABasicAnimation(keyPath: AnimationKeyPath.foregroundColor.rawValue)
        textColorAnimation.duration            = animationDuration
        textColorAnimation.autoreverses        = true
        textColorAnimation.repeatCount         = AnimationConstants.repeatCount
        textColorAnimation.removedOnCompletion = false
        textColorAnimation.timingFunction      = animationTimingFunction.timingFunction
        textColorAnimation.fromValue           = animationTextColor.colorWithAlphaComponent(AnimationConstants.fromTextColorAlpha).CGColor
        textColorAnimation.toValue             = animationTextColor.CGColor
        textLayer.foregroundColor = animationTextColor.CGColor
        textLayer.addAnimation(textColorAnimation, forKey: "TextColor")
    }
    
    private func animateRipple() {
        let fadeOutOpacity = CABasicAnimation(keyPath: AnimationKeyPath.opacity.rawValue)
        fadeOutOpacity.fromValue = 1
        fadeOutOpacity.toValue   = 0

        let scale = CABasicAnimation(keyPath: AnimationKeyPath.transformScale.rawValue)
        scale.fromValue = AnimationConstants.rippleFromScale
        scale.toValue   = 1

        let animationGroup = CAAnimationGroup()
        animationGroup.duration       = animationDuration
        animationGroup.repeatCount    = AnimationConstants.repeatCount
        animationGroup.timingFunction = animationTimingFunction.timingFunction
        animationGroup.animations     = [fadeOutOpacity, scale]

        rippleLayer.addAnimation(animationGroup, forKey: nil)
        subRippleLayer.addAnimation(animationGroup, forKey: nil)
    }
}
