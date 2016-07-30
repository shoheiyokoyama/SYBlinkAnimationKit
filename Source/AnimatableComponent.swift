//
//  AnimatableComponent.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/01/17.
//
//

import UIKit

struct AnimationDefaultColor {
    static let border     = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1)
    static let background = UIColor(red: 248/255, green: 148/255, blue: 6/255, alpha: 1)
    static let text       = UIColor(red: 214/255, green: 69/255, blue: 65/255, alpha: 1)
    static let ripple     = UIColor(red: 75/255, green: 119/255, blue: 190/255, alpha: 1)
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