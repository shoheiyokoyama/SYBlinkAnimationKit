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
    
    
    let borderButton = SYButton()
    let border2Button = SYButton()
    let backgroundButton = SYButton()
    let textButton = SYButton()
    let rippleButton = SYButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.borderButton.frame = CGRectMake(40, 50, 300, 50)
        self.borderButton.setTitle("Border Animation", forState: .Normal)
        self.borderButton.setTitleColor(UIColor.blackColor(), forState: .Normal) // FIXME: set defalt black color
        self.borderButton.animationBorderColor = UIColor.orangeColor() // TODO: set color
        self.borderButton.addTarget(self, action: "borderAnimation:", forControlEvents: .TouchUpInside)
        self.borderButton.syButtonAnimation = .Border
        self.view.addSubview(self.borderButton)
        
        self.border2Button.frame = CGRectMake(40, 110, 300, 50)
        self.border2Button.setTitle("BorderWithLight Animation", forState: .Normal)
        self.border2Button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.border2Button.animationBorderColor = UIColor.blueColor()
        self.border2Button.addTarget(self, action: "borderWithLightAnimation:", forControlEvents: .TouchUpInside)
        self.border2Button.syButtonAnimation = .BorderWithLight
        self.view.addSubview(self.border2Button)
        
        self.backgroundButton.frame = CGRectMake(40, 170, 300, 50)
        self.backgroundButton.setTitle("Background Animation", forState: .Normal)
        self.backgroundButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.backgroundButton.animationBackgroundColor = UIColor.redColor()
        self.backgroundButton.addTarget(self, action: "BackgroundAnimation:", forControlEvents: .TouchUpInside)
        self.backgroundButton.syButtonAnimation = .Background
        self.view.addSubview(self.backgroundButton)
        
        self.textButton.frame = CGRectMake(40, 230, 300, 50)
        self.textButton.setTitle("Text Animation", forState: .Normal)
        self.textButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.textButton.buttonColor = UIColor.lightGrayColor()
        self.textButton.animationTextColor = UIColor.blueColor()
        self.textButton.addTarget(self, action: "textAnimation:", forControlEvents: .TouchUpInside)
        self.textButton.syButtonAnimation = .Text
        self.view.addSubview(self.textButton)
        
        self.rippleButton.frame = CGRectMake(40, 290, 300, 50)
        self.rippleButton.setTitle("Ripple Animation", forState: .Normal)
        self.rippleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.rippleButton.buttonColor = UIColor.blueColor()
        self.rippleButton.animationRippleColor = UIColor.redColor()
        self.rippleButton.addTarget(self, action: "rippleAnimation:", forControlEvents: .TouchUpInside)
        self.rippleButton.syButtonAnimation = .Ripple
        self.view.addSubview(self.rippleButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SYButton Tap Events -
    internal func borderAnimation(sender: SYButton) {
        self.borderButton.isAnimating ? self.borderButton.stopAnimation() : self.borderButton.startAnimation()
    }
    
    internal func borderWithLightAnimation(sender: SYButton) {
        self.border2Button.isAnimating ? self.border2Button.stopAnimation() : self.border2Button.startAnimation()
    }
    
    internal func BackgroundAnimation(sender: SYButton) {
        self.backgroundButton.isAnimating ? self.backgroundButton.stopAnimation() : self.backgroundButton.startAnimation()
    }
    
    internal func textAnimation(sender: SYButton) {
        self.textButton.isAnimating ? self.textButton.stopAnimation() : self.textButton.startAnimation()
    }
    
    internal func rippleAnimation(sender: SYButton) {
        self.rippleButton.isAnimating ? self.rippleButton.stopAnimation() : self.rippleButton.startAnimation()
    }
}
