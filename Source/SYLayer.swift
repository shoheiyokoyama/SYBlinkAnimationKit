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
    case Linear = 0
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

struct Const {
    static let borderWidthForAnimation: CGFloat = 1.0
}

public class SYLayer {
    
    private var superLayer: CALayer!
    private var textLayer = CATextLayer()
    private var rippleLayer = CALayer()
    private var subRippleLayer = CALayer()
    
    private var borderColorAnimtion = CABasicAnimation()
    private var borderWidthAnimation = CABasicAnimation()
    private var shadowAnimation = CABasicAnimation()
    private var backgroundColorAnimation = CABasicAnimation()
    private var textColorAnimation = CABasicAnimation()
    
    private var animationBorderColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1) {
        didSet {
            borderColorAnimtion.toValue = animationBorderColor.CGColor
            animationShadowColor = animationBorderColor
        }
    }
    private var animationTextColor = UIColor(red: 214/255, green: 69/255, blue: 65/255, alpha: 1) {
        didSet {
            textColorAnimation.toValue = animationTextColor.CGColor
        }
    }
    private var animationBackgroundColor = UIColor(red: 248/255, green: 148/255, blue: 6/255, alpha: 1) {
        didSet {
            backgroundColorAnimation.toValue = animationBackgroundColor.CGColor
        }
    }
    private var animationShadowColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1) {
        didSet {
            superLayer.shadowColor = animationShadowColor.CGColor
        }
    }
    private var animationRippleColor = UIColor(red: 171/255, green: 183/255, blue: 183/255, alpha: 1) {
        didSet {
            rippleLayer.backgroundColor = animationRippleColor.CGColor
            subRippleLayer.borderColor = animationRippleColor.CGColor
        }
    }
    
    private var animationDuration: CFTimeInterval = 1.5
    private var animationTimingFunction: SYMediaTimingFunction = .Linear
    
    private var textColor = UIColor.blackColor()
    private var backgroundColor = UIColor.clearColor() {
        didSet {
            superLayer.backgroundColor = backgroundColor.CGColor
        }
    }
    
    private var borderWidth: CGFloat = 0.0 {
        didSet {
            superLayer.borderWidth = borderWidth
        }
    }
    private var borderColor = UIColor.clearColor() {
        didSet {
            superLayer.borderColor = borderColor.CGColor
        }
    }
    
    private var shadowRadius: CGFloat = 0.0 {
        didSet {
            superLayer.shadowRadius = shadowRadius
        }
    }
    private var shadowOpacity: Float = 0.0 {
        didSet {
            superLayer.shadowOpacity = shadowOpacity
        }
    }
    private var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            superLayer.shadowOffset = shadowOffset
        }
    }
    
    public init(sLayer: CALayer) {
        superLayer = sLayer
        
        setLayer()
    }
    
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

    public func setBackgroundColor(bgColor: UIColor) {
        backgroundColor = bgColor
    }
    public func setTextColor(tColor: UIColor) {
        textColor = tColor
    }

    public func setAnimationTimingFunction(timingFunction: SYMediaTimingFunction) {
        animationTimingFunction = timingFunction
    }
    
    public func setAnimationDuration(aniDuration: CFTimeInterval) {
        animationDuration = aniDuration
    }
    
    public func resizeSuperLayer() {
        resizeRippleLayer()
        resizeTextLayer()
        resizeShadowPath()
    }
    
    public func firstSetTextLayer(tLayer: CATextLayer) {
        textLayer = tLayer
        superLayer.insertSublayer(textLayer, atIndex: 0)
    }
    
    public func resetTextLayer(tLayer: CATextLayer) {
        textLayer = tLayer
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

private extension SYLayer {
    
    private func setLayer() {
        superLayer.shadowColor  = animationShadowColor.CGColor
        superLayer.borderColor  = borderColor.CGColor

        superLayer.borderWidth  = borderWidth

        superLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        setRippleLayer()
    }
    
    private func setRippleLayer() {
        setRippleLayerPosition()
        rippleLayer.opacity    = 0.0
        superLayer.addSublayer(rippleLayer)

        subRippleLayer.opacity = 0.0
        superLayer.insertSublayer(subRippleLayer, atIndex: 1)
    }
    
    private func setRippleLayerPosition() {
        let superLayerHeight               = CGRectGetHeight(superLayer.frame)

        let rippleDiameter: CGFloat        = superLayerHeight * 0.7
        let rippleCornerRadius: CGFloat    = rippleDiameter / 2

        rippleLayer.backgroundColor        = animationRippleColor.CGColor
        rippleLayer.cornerRadius           = rippleCornerRadius
        rippleLayer.frame                  = CGRect(x: (superLayer.bounds.width - rippleDiameter) / 2, y: (superLayer.bounds.height - rippleDiameter) / 2, width: rippleDiameter, height: rippleDiameter)

        let subRippleDiameter: CGFloat     = superLayerHeight * 0.85
        let subRippleCornerRadius: CGFloat = subRippleDiameter / 2

        subRippleLayer.borderColor         = animationRippleColor.CGColor
        subRippleLayer.borderWidth         = 1
        subRippleLayer.backgroundColor     = UIColor.clearColor().CGColor
        subRippleLayer.cornerRadius        = subRippleCornerRadius
        subRippleLayer.frame               = CGRect(x: (superLayer.bounds.width - subRippleDiameter) / 2, y: (superLayer.bounds.height - subRippleDiameter) / 2, width: subRippleDiameter, height: subRippleDiameter)
    }
    
    private func resetSuperLayerShadow() {
        if CGColorGetAlpha(backgroundColor.CGColor) == 1.0 {
            superLayer.shadowPath   = UIBezierPath(rect: superLayer.bounds).CGPath
            superLayer.shadowRadius = 4.0
            return
        }
        
        let bw: CGFloat               = Const.borderWidthForAnimation * 2.0
        let bwh: CGFloat              = bw / 2
        let sw                        = superLayer.frame.width
        let sh                        = superLayer.frame.height
        let c                         = superLayer.cornerRadius

        let pathRef: CGMutablePathRef = CGPathCreateMutable()

        CGPathMoveToPoint(pathRef   , nil, -bwh        , -bwh + c)

        CGPathAddArcToPoint(pathRef , nil, -bwh        , -bwh    , -bwh + c    , -bwh        , c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh - c, -bwh)
        CGPathAddArcToPoint(pathRef , nil, sw+bwh      , -bwh    , sw + bwh    , -bwh+c      , c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh    , bwh + c)
        CGPathAddArcToPoint(pathRef , nil, sw - bwh    , bwh     , sw - bwh - c, bwh         , c)

        CGPathAddLineToPoint(pathRef, nil, bwh + c     , bwh)
        CGPathAddArcToPoint(pathRef , nil, bwh         , bwh     , bwh         , bwh + c     , c)

        CGPathAddLineToPoint(pathRef, nil, bwh         , sh - bwh - c)
        CGPathAddArcToPoint(pathRef , nil, bwh         , sh - bwh, bwh + c     , sh - bwh    , c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh - c, sh - bwh)
        CGPathAddArcToPoint(pathRef , nil, sw - bwh    , sh - bwh, sw - bwh    , sh - bwh - c, c)

        CGPathAddLineToPoint(pathRef, nil, sw - bwh    , bwh + c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh    , -bwh + c)
        CGPathAddLineToPoint(pathRef, nil, sw + bwh    , sh + bwh - c)
        CGPathAddArcToPoint(pathRef , nil, sw + bwh    , sh + bwh, sw + bwh - c, sh + bwh    , c)

        CGPathAddLineToPoint(pathRef, nil, -bwh + c    , sh + bwh)
        CGPathAddArcToPoint(pathRef , nil, -bwh        , sh + bwh, -bwh        , sh + bwh - c, c)

        CGPathAddLineToPoint(pathRef, nil, -bwh        , -bwh + c)

        CGPathCloseSubpath(pathRef)
        superLayer.shadowPath         = pathRef
        superLayer.shadowRadius       = 2.5
    }
    
    private func resizeRippleLayer() {
        setRippleLayerPosition()
    }
    
    private func resizeTextLayer() {
        let superLayerHeight     = CGRectGetHeight(superLayer.frame)
        let superLayerWidth      = CGRectGetWidth(superLayer.frame)

        textLayer.frame.origin.x = (superLayerWidth - textLayer.frame.width) / 2
        textLayer.frame.origin.y = (superLayerHeight - textLayer.frame.height) / 2
    }
    
    private func resizeShadowPath() {
        resetSuperLayerShadow()
    }
    
    private func setBorderAnimation() {
        setBorderColorAnimation()
        setBorderWidthAnimation(0.0, toValue: Const.borderWidthForAnimation)
    }
    
    private func setBorderWithShadowAnimation() {
        setBorderColorAnimation()
        setShadowAnimation(0.0, toValue: 0.5)
        setBorderWidthAnimation(0.0, toValue: Const.borderWidthForAnimation)
    }
    
    private func setBorderColorAnimation() {
        borderColorAnimtion           = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimtion.fromValue = UIColor.clearColor().CGColor
        borderColorAnimtion.toValue   = animationBorderColor.CGColor
    }
    
    private func setBorderWidthAnimation(fromValue: CGFloat, toValue: CGFloat) {
        borderWidthAnimation           = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.fromValue = fromValue
        borderWidthAnimation.toValue   = toValue
    }
    
    private func setShadowAnimation(fromValue: Float, toValue: Float) {
        shadowAnimation           = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = fromValue
        shadowAnimation.toValue   = toValue
    }
    
    private func animateBorderOrBorderWithShadow() {
        let groupAnimation            = CAAnimationGroup()
        groupAnimation.duration       = animationDuration
        groupAnimation.animations     = [borderColorAnimtion, borderWidthAnimation]
        groupAnimation.timingFunction = animationTimingFunction.timingFunction
        groupAnimation.delegate       = self
        groupAnimation.autoreverses   = true
        groupAnimation.repeatCount    = 1e100
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
        backgroundColorAnimation                = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue      = UIColor.clearColor().CGColor
        backgroundColorAnimation.toValue        = animationBackgroundColor.CGColor
        backgroundColorAnimation.duration       = animationDuration
        backgroundColorAnimation.autoreverses   = true
        backgroundColorAnimation.repeatCount    = 1e100
        backgroundColorAnimation.timingFunction = animationTimingFunction.timingFunction
        superLayer.addAnimation(backgroundColorAnimation, forKey: "Background")
    }
    
    private func animateText() {
        textColorAnimation                     = CABasicAnimation(keyPath: "foregroundColor")
        textColorAnimation.duration            = animationDuration
        textColorAnimation.autoreverses        = true
        textColorAnimation.repeatCount         = 1e100
        textColorAnimation.removedOnCompletion = false
        textColorAnimation.timingFunction      = animationTimingFunction.timingFunction
        textColorAnimation.fromValue           = animationTextColor.colorWithAlphaComponent(0.15).CGColor
        textColorAnimation.toValue             = animationTextColor.CGColor
        textLayer.foregroundColor              = animationTextColor.CGColor
        textLayer.addAnimation(textColorAnimation, forKey: "TextColor")
    }
    
    private func animateRipple() {
        let fadeOutOpacity            = CABasicAnimation(keyPath: "opacity")
        fadeOutOpacity.fromValue      = 1.0
        fadeOutOpacity.toValue        = 0.0

        let scale                     = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue               = 0.4
        scale.toValue                 = 1.0

        let animationGroup            = CAAnimationGroup()
        animationGroup.duration       = animationDuration
        animationGroup.repeatCount    = 1e100
        animationGroup.timingFunction = animationTimingFunction.timingFunction
        animationGroup.animations     = [fadeOutOpacity, scale]

        rippleLayer.addAnimation(animationGroup, forKey: nil)
        subRippleLayer.addAnimation(animationGroup, forKey: nil)
    }
}
