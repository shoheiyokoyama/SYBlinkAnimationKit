//
//  AnimatableComponent.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/01/17.
//
//

import UIKit

struct AnimationDefaultColor {
    static let border     = UIColor(hex: 0x36D7B7)
    static let background = UIColor(hex: 0xF89406)
    static let text       = UIColor(hex: 0xD64541)
    static let ripple     = UIColor(hex: 0x4B77BE)
}

protocol AnimatableComponent {
    var animationBorderColor: UIColor {get set}
    var animationBackgroundColor: UIColor {get set}
    var animationRippleColor: UIColor {get set}
    
    var isAnimating: Bool {get set}
    
    var animationTimingFunction: SYMediaTimingFunction {get set}
    var animationTimingAdapter: Int {get set}
    var animationDuration: CGFloat {get set}

    func startAnimation()
    func stopAnimation()
}

extension AnimatableComponent where Self: UIView {}