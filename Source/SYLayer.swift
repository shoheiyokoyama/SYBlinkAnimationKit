//
//  SYLayer.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

final class SYLayer: Animatable {
    var superLayer: CALayer     = .init()
    var textLayer: CATextLayer  = .init()
    var rippleLayer: CALayer    = .init()
    var subRippleLayer: CALayer = .init()
    
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
    
    var textColor: UIColor = .black
    var backgroundColor: UIColor = .white {
        didSet {
            superLayer.backgroundColor = backgroundColor.cgColor
        }
    }
    
    var animationBackgroundColor = AnimationDefaultColor.background
    var animationTextColor       = AnimationDefaultColor.text
    var animationBorderColor     = AnimationDefaultColor.border {
        didSet {
            animationShadowColor = animationBorderColor
        }
    }
    
    var borderColorAnimtion: CABasicAnimation  = .init(type: .borderColor)
    var borderWidthAnimation: CABasicAnimation = .init(type: .borderWidth)
    var shadowAnimation: CABasicAnimation      = .init(type: .shadowOpacity)

    fileprivate var animationShadowColor = AnimationDefaultColor.border {
        didSet {
            superLayer.shadowColor = animationShadowColor.cgColor
        }
    }
    fileprivate var animationRippleColor = AnimationDefaultColor.ripple {
        didSet {
            rippleLayer.backgroundColor = animationRippleColor.cgColor
            subRippleLayer.borderColor = animationRippleColor.cgColor
        }
    }
    
    fileprivate var borderWidth: CGFloat = 0 {
        didSet {
            superLayer.borderWidth = borderWidth
        }
    }
    fileprivate var borderColor: UIColor = .white {
        didSet {
            superLayer.borderColor = borderColor.cgColor
        }
    }
    
    fileprivate var shadowRadius: CGFloat = 0 {
        didSet {
            superLayer.shadowRadius = shadowRadius
        }
    }
    fileprivate var shadowOpacity: Float = 0 {
        didSet {
            superLayer.shadowOpacity = shadowOpacity
        }
    }
    fileprivate var shadowOffset: CGSize = .zero {
        didSet {
            superLayer.shadowOffset = shadowOffset
        }
    }
    
    // MARK: - initializer -
    
    init(layer: CALayer) {
        superLayer = layer
        configure()
    }
    
    // MARK: - Internal Methods -
    
    func setBorderColor(_ borderColor: UIColor) {
        animationBorderColor = borderColor
    }
    func setAnimationBackgroundColor(_ backgroundColor: UIColor) {
        animationBackgroundColor = backgroundColor
    }
    func setAnimationTextColor(_ textColor: UIColor) {
        animationTextColor = textColor
    }
    func setRippleColor(_ rippleColor: UIColor) {
        animationRippleColor = rippleColor
    }
    func setBackgroundColor(_ backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    func setTextColor(_ textColor: UIColor) {
        self.textColor = textColor
    }
    func setTimingFunction(_ timingFunction: SYMediaTimingFunction) {
        animationTimingFunction = timingFunction
    }
    func setAnimationDuration(_ animationDuration: CFTimeInterval) {
        self.animationDuration = animationDuration
    }
    
    func resizeSuperLayer() {
        resizeRippleLayer()
        resizeTextLayer()
        resizeShadowPath()
    }
    
    func resetTextLayer(_ textLayer: CATextLayer) {
        self.textLayer = textLayer
        if let sublayers = superLayer.sublayers , sublayers.contains (where: { $0 === textLayer }) == false {
            superLayer.insertSublayer(self.textLayer, at: 0)
        }
    }
}

// MARK: - Fileprivate Methods -

fileprivate extension SYLayer {
    
    func configure() {
        superLayer.shadowColor  = animationShadowColor.cgColor
        superLayer.borderColor  = borderColor.cgColor
        superLayer.borderWidth  = borderWidth
        superLayer.shadowOffset = .zero
        
        setRippleLayer()
    }
    
    func setRippleLayer() {
        configureRippleLayer()
        rippleLayer.opacity = 0
        superLayer.addSublayer(rippleLayer)

        subRippleLayer.opacity = 0
        superLayer.insertSublayer(subRippleLayer, at: 1)
    }
    
    func configureRippleLayer() {
        let height = superLayer.frame.height

        let diameter: CGFloat     = height * AnimationConstants.rippleDiameterRatio
        let cornerRadius: CGFloat = diameter / 2

        rippleLayer.backgroundColor = animationRippleColor.cgColor
        rippleLayer.cornerRadius    = cornerRadius
        rippleLayer.frame           = CGRect(x: (superLayer.bounds.width - diameter) / 2, y: (superLayer.bounds.height - diameter) / 2, width: diameter, height: diameter)

        let subDiameter: CGFloat     = height * AnimationConstants.subRippleDiameterRatio
        let subCornerRadius: CGFloat = subDiameter / 2

        subRippleLayer.borderColor     = animationRippleColor.cgColor
        subRippleLayer.borderWidth     = AnimationConstants.rippleBorderWidth
        subRippleLayer.backgroundColor = UIColor.clear.cgColor
        subRippleLayer.cornerRadius    = subCornerRadius
        subRippleLayer.frame           = CGRect(x: (superLayer.bounds.width - subDiameter) / 2, y: (superLayer.bounds.height - subDiameter) / 2, width: subDiameter, height: subDiameter)
    }
    
    func resizeRippleLayer() {
        configureRippleLayer()
    }
    
    func resizeTextLayer() {
        let superLayerHeight = superLayer.frame.height
        let superLayerWidth  = superLayer.frame.width

        textLayer.frame.origin.x = (superLayerWidth - textLayer.frame.width) / 2
        textLayer.frame.origin.y = (superLayerHeight - textLayer.frame.height) / 2
    }
    
    func resizeShadowPath() {
        resetSuperLayerShadow()
    }
}
