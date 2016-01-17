//
//  Animatable.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/01/17.
//
//

import UIKit

protocol Animatable {
    var animationBorderColor: UIColor {get set}
    var animationBackgroundColor: UIColor {get set}
    var animationRippleColor: UIColor {get set}
    
    var isAnimating: Bool {get set}
    
    var animationTimingFunction: SYMediaTimingFunction {get set}
    var animationDuration: CGFloat {get set}
    
    var syLayer: SYLayer {get set}
    
    func startAnimation()
    func stopAnimation()
}