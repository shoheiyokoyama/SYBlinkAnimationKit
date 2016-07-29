//
//  Animator.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/29.
//
//

import UIKit

struct AnimationConstants {
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

enum AnimationKeyType: String {
    case borderColor
    case borderWidth
    case shadowOpacity
    case backgroundColor
    case foregroundColor
    case opacity
    case transformScale  = "transform.scale"
    
    var fromValue: AnyObject {
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

public enum SYMediaTimingFunction: Int {
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
    
    var timingFunction : CAMediaTimingFunction {
        switch self {
        case .linear:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        case .easeIn:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        case .easeInEaseOut:
            return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
    }
}

enum AnimationType {
    case border
    case borderWithShadow
    case background
    case ripple
    case text
}

// MARK: - Protocol -

protocol Animatable {
    var borderColorAnimtion: CABasicAnimation { get set }
    var borderWidthAnimation: CABasicAnimation { get set }
    var shadowAnimation: CABasicAnimation { get set }
    
    var animationType: AnimationType { get set }
    
    var superLayer: CALayer { get set }
    var textLayer: CATextLayer { get set }
    var subRippleLayer: CALayer { get set }
    var rippleLayer: CALayer { get set }
    
    var animationDuration: CFTimeInterval { get set }
    var animationTimingFunction: SYMediaTimingFunction { get set }
    
    var textColor: UIColor { get set }
    var backgroundColor: UIColor { get set }
    
    var animationBorderColor: UIColor { get set }
    var animationBackgroundColor: UIColor { get set }
    var animationTextColor: UIColor { get set }
}

extension Animatable {
    func startAnimation() {
        switch animationType {
        case .border:
            animateBorder()
        case .borderWithShadow:
            animateBorder()
        case .background:
            animateBackground()
        case .text:
            animateText()
        case .ripple:
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
    
    func configureBorderAnimation() {
        configureBorderColorAnimation()
        configureBorderWidthAnimation()
    }
    
    func configureBorderWithShadowAnimation() {
        configureBorderColorAnimation()
        configureShadowAnimation()
        configureBorderWidthAnimation()
    }
    
    func animateBorder() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration       = animationDuration
        groupAnimation.animations     = [borderColorAnimtion, borderWidthAnimation]
        groupAnimation.timingFunction = animationTimingFunction.timingFunction
        groupAnimation.autoreverses   = true
        groupAnimation.repeatCount    = AnimationConstants.repeatCount
        animationType == .borderWithShadow ? animateBorderWithShadow(groupAnimation) : superLayer.addAnimation(groupAnimation, forKey: nil)
    }
    
    func animateBorderWithShadow(groupAnimation: CAAnimationGroup) {
        resetSuperLayerShadow()
        
        superLayer.masksToBounds   = false
        superLayer.backgroundColor = backgroundColor.CGColor
        groupAnimation.animations?.append(shadowAnimation)
        superLayer.addAnimation(groupAnimation, forKey: nil)
    }
    
    func animateBackground() {
        let backgroundColorAnimation = CABasicAnimation(type: .backgroundColor)
        backgroundColorAnimation.fromValue      = AnimationKeyType.backgroundColor.fromValue
        backgroundColorAnimation.toValue        = animationBackgroundColor.CGColor
        backgroundColorAnimation.duration       = animationDuration
        backgroundColorAnimation.autoreverses   = true
        backgroundColorAnimation.repeatCount    = AnimationConstants.repeatCount
        backgroundColorAnimation.timingFunction = animationTimingFunction.timingFunction
        superLayer.addAnimation(backgroundColorAnimation, forKey: nil)
    }
    
    func animateText() {
        let textColorAnimation = CABasicAnimation(type: .foregroundColor)
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
    
    func animateRipple() {
        let fadeOutOpacity = CABasicAnimation(type: .opacity)
        fadeOutOpacity.fromValue = AnimationKeyType.opacity.fromValue
        fadeOutOpacity.toValue   = AnimationConstants.rippleToAlpha
        
        let scale = CABasicAnimation(type: .transformScale)
        scale.fromValue = AnimationKeyType.transformScale.fromValue
        scale.toValue   = AnimationConstants.rippleToScale
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration       = animationDuration
        animationGroup.repeatCount    = AnimationConstants.repeatCount
        animationGroup.timingFunction = animationTimingFunction.timingFunction
        animationGroup.animations     = [fadeOutOpacity, scale]
        
        rippleLayer.addAnimation(animationGroup, forKey: nil)
        subRippleLayer.addAnimation(animationGroup, forKey: nil)
    }
    
    func resetSuperLayerShadow() {
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
}
