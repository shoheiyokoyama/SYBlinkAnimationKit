//
//  Animatable.swift
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
    static let fromTextColorAlpha: CGFloat     = 0.15
    static let rippleToAlpha: CGFloat          = 0
    static let rippleToScale: CGFloat          = 1
}

enum AnimationKeyType: String {
    case borderColor, borderWidth, shadowOpacity, backgroundColor, foregroundColor, opacity, transformScale  = "transform.scale"
    
    var fromValue: AnyObject {
        switch self {
        case .borderColor, .backgroundColor, .foregroundColor/* Don't use */:
            return UIColor.clear.cgColor
        case .borderWidth, .shadowOpacity:
            return 0 as AnyObject
        case .opacity:
            return 1 as AnyObject
        case .transformScale:
            return 0.4 as AnyObject
        }
    }
}

public enum SYMediaTimingFunction: Int {
    case linear, easeIn, easeOut, easeInEaseOut
    
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
    case border, borderWithShadow, background, ripple, text
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
        case .border, .borderWithShadow:
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
        
        textLayer.foregroundColor = textColor.cgColor
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
        groupAnimation.duration            = animationDuration
        groupAnimation.animations          = [borderColorAnimtion, borderWidthAnimation]
        groupAnimation.timingFunction      = animationTimingFunction.timingFunction
        groupAnimation.autoreverses        = true
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.repeatCount         = 1e100
        animationType == .borderWithShadow ? animateBorderWithShadow(groupAnimation) : superLayer.add(groupAnimation, forKey: nil)
    }
    
    func animateBorderWithShadow(_ groupAnimation: CAAnimationGroup) {
        resetSuperLayerShadow()
        
        superLayer.masksToBounds   = false
        superLayer.backgroundColor = backgroundColor.cgColor
        groupAnimation.animations?.append(shadowAnimation)
        superLayer.add(groupAnimation, forKey: nil)
    }
    
    func animateBackground() {
        let backgroundColorAnimation = CABasicAnimation(type: .backgroundColor)
        backgroundColorAnimation.fromValue           = AnimationKeyType.backgroundColor.fromValue
        backgroundColorAnimation.toValue             = animationBackgroundColor.cgColor
        backgroundColorAnimation.duration            = animationDuration
        backgroundColorAnimation.autoreverses        = true
        backgroundColorAnimation.isRemovedOnCompletion = false
        backgroundColorAnimation.repeatCount         = 1e100
        backgroundColorAnimation.timingFunction      = animationTimingFunction.timingFunction
        superLayer.add(backgroundColorAnimation, forKey: nil)
    }
    
    func animateText() {
        let textColorAnimation = CABasicAnimation(type: .foregroundColor)
        textColorAnimation.duration            = animationDuration
        textColorAnimation.autoreverses        = true
        textColorAnimation.repeatCount         = 1e100
        textColorAnimation.isRemovedOnCompletion = false
        textColorAnimation.timingFunction      = animationTimingFunction.timingFunction
        textColorAnimation.fromValue           = animationTextColor.withAlphaComponent(AnimationConstants.fromTextColorAlpha).cgColor
        textColorAnimation.toValue             = animationTextColor.cgColor
        
        textLayer.foregroundColor = animationTextColor.cgColor
        textLayer.add(textColorAnimation, forKey: nil)
    }
    
    func animateRipple() {
        let fadeOutOpacity = CABasicAnimation(type: .opacity)
        fadeOutOpacity.fromValue = AnimationKeyType.opacity.fromValue
        fadeOutOpacity.toValue   = AnimationConstants.rippleToAlpha
        
        let scale = CABasicAnimation(type: .transformScale)
        scale.fromValue = AnimationKeyType.transformScale.fromValue
        scale.toValue   = AnimationConstants.rippleToScale
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration            = animationDuration
        animationGroup.repeatCount         = 1e100
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction      = animationTimingFunction.timingFunction
        animationGroup.animations          = [fadeOutOpacity, scale]
        
        rippleLayer.add(animationGroup, forKey: nil)
        subRippleLayer.add(animationGroup, forKey: nil)
    }
    
    func resetSuperLayerShadow() {
        if backgroundColor.cgColor.alpha == 1 {
            superLayer.shadowPath   = UIBezierPath(rect: superLayer.bounds).cgPath
            superLayer.shadowRadius = AnimationConstants.shadowRadiusIfNotClear
            return
        }
        
        let bw: CGFloat  = AnimationConstants.borderWidth * 2
        let bwh: CGFloat = bw / 2
        let sw = superLayer.frame.width
        let sh = superLayer.frame.height
        let c  = superLayer.cornerRadius
        
        let pathRef = CGMutablePath()

        pathRef.move(to: CGPoint(x: -bwh, y: -bwh + c))
        
        pathRef.addArc(tangent1End: CGPoint(x: -bwh, y: -bwh), tangent2End: CGPoint(x: -bwh + c, y: -bwh), radius: c)
        pathRef.addLine(to: CGPoint(x: sw + bwh - c, y: -bwh))
        pathRef.addArc(tangent1End: CGPoint(x: sw+bwh, y: -bwh), tangent2End: CGPoint(x: sw + bwh, y: -bwh+c), radius: c)
        
        pathRef.addLine(to: CGPoint(x: sw - bwh, y: bwh + c))
        pathRef.addArc(tangent1End: CGPoint(x: sw - bwh, y: bwh), tangent2End: CGPoint(x: sw - bwh - c, y: bwh), radius: c)
        
        pathRef.addLine(to: CGPoint(x: bwh + c, y: bwh))
        pathRef.addArc(tangent1End: CGPoint(x: bwh, y: bwh), tangent2End: CGPoint(x: bwh, y: bwh + c), radius: c)
        
        pathRef.addLine(to: CGPoint(x: bwh, y: sh - bwh - c))
        pathRef.addArc(tangent1End: CGPoint(x: bwh, y: sh - bwh), tangent2End: CGPoint(x: bwh + c, y: sh - bwh), radius: c)
        
        pathRef.addLine(to: CGPoint(x: sw - bwh - c, y: sh - bwh))
        pathRef.addArc(tangent1End: CGPoint(x: sw - bwh, y: sh - bwh), tangent2End: CGPoint(x: sw - bwh, y: sh - bwh - c), radius: c)
        
        pathRef.addLine(to: CGPoint(x: sw - bwh, y: bwh + c))
        pathRef.addLine(to: CGPoint(x: sw + bwh, y: -bwh + c))
        pathRef.addLine(to: CGPoint(x: sw + bwh, y: sh + bwh - c))
        pathRef.addArc(tangent1End: CGPoint(x: sw + bwh, y: sh + bwh), tangent2End: CGPoint(x: sw + bwh - c, y: sh + bwh), radius: c)
        
        pathRef.addLine(to: CGPoint(x: -bwh + c, y: sh + bwh))
        pathRef.addArc(tangent1End: CGPoint(x: -bwh, y: sh + bwh), tangent2End: CGPoint(x: -bwh, y: sh + bwh - c), radius: c)
        
        pathRef.addLine(to: CGPoint(x: -bwh, y: -bwh + c))
        
        pathRef.closeSubpath()
        
        superLayer.shadowPath   = pathRef
        superLayer.shadowRadius = AnimationConstants.shadowRadius
    }
    
    fileprivate func configureBorderColorAnimation() {
        borderColorAnimtion.fromValue = AnimationKeyType.borderColor.fromValue
        borderColorAnimtion.toValue   = animationBorderColor.cgColor
    }
    
    fileprivate func configureBorderWidthAnimation() {
        borderWidthAnimation.fromValue = AnimationKeyType.borderWidth.fromValue
        borderWidthAnimation.toValue   = AnimationConstants.borderWidth
    }
    
    fileprivate func configureShadowAnimation() {
        shadowAnimation.fromValue = AnimationKeyType.shadowOpacity.fromValue
        shadowAnimation.toValue   = AnimationConstants.shadowOpacity
    }
}
