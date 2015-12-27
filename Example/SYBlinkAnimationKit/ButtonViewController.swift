//
//  ButtonViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 2015/12/13.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class ButtonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let borderButton = SYButton(frame: CGRectMake(40, 50, 300, 50))
        borderButton.setTitle("Border Animation", forState: .Normal)
//        borderButton.animationBorderColor = UIColor.orangeColor()
        borderButton.addTarget(self, action: "borderAnimation:", forControlEvents: .TouchUpInside)
//        borderButton.syButtonAnimation = .Border
        self.view.addSubview(borderButton)
        
        let border2Button = SYButton(frame: CGRectMake(40, 110, 300, 50))
        border2Button.setTitle("BorderWithShadow Animation", forState: .Normal)
//        border2Button.animationBorderColor = UIColor.blueColor()
        border2Button.addTarget(self, action: "BorderWithShadowAnimation:", forControlEvents: .TouchUpInside)
        border2Button.syButtonAnimation = .BorderWithShadow
        self.view.addSubview(border2Button)
        
        let backgroundButton = SYButton(frame: CGRectMake(40, 170, 300, 50))
        backgroundButton.setTitle("Background Animation", forState: .Normal)
//        backgroundButton.animationBackgroundColor = UIColor.redColor()
        backgroundButton.addTarget(self, action: "BackgroundAnimation:", forControlEvents: .TouchUpInside)
        backgroundButton.syButtonAnimation = .Background
        self.view.addSubview(backgroundButton)
        
        let textButton = SYButton(frame: CGRectMake(40, 230, 300, 50))
        textButton.setTitle("Text Animation", forState: .Normal)
        textButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        textButton.backgroundColor = UIColor.blackColor()
//        textButton.animationTextColor = UIColor.blueColor()
        textButton.addTarget(self, action: "textAnimation:", forControlEvents: .TouchUpInside)
        textButton.syButtonAnimation = .Text
        self.view.addSubview(textButton)
        
        let rippleButton = SYButton(frame: CGRectMake(40, 290, 300, 50))
        rippleButton.setTitle("Ripple Animation", forState: .Normal)
        rippleButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        rippleButton.backgroundColor = UIColor.lightGrayColor()
//        rippleButton.animationRippleColor = UIColor.redColor()
        rippleButton.addTarget(self, action: "rippleAnimation:", forControlEvents: .TouchUpInside)
        rippleButton.syButtonAnimation = .Ripple
        self.view.addSubview(rippleButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SYButton Tap Events -
    internal func borderAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BorderWithShadowAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BackgroundAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func textAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func rippleAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
}
