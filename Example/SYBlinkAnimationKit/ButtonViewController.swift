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
    
    @IBOutlet weak var borderButton: SYButton!
    @IBOutlet weak var border2Button: SYButton!
    @IBOutlet weak var backgroundButton: SYButton!
    @IBOutlet weak var textButton: SYButton!
    @IBOutlet weak var rippleButton: SYButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "SYButton"
        
        borderButton.setTitle("Border Animation", forState: .Normal)
        borderButton.addTarget(self, action: #selector(ButtonViewController.borderAnimation(_:)), forControlEvents: .TouchUpInside)
        borderButton.startAnimation()
        self.view.addSubview(borderButton)
        
        border2Button.setTitle("BorderWithShadow Animation", forState: .Normal)
        border2Button.animationBorderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        border2Button.addTarget(self, action: #selector(ButtonViewController.BorderWithShadowAnimation(_:)), forControlEvents: .TouchUpInside)
        border2Button.animationType = .borderWithShadow
        border2Button.startAnimation()
        self.view.addSubview(border2Button)
        
        backgroundButton.setTitle("Background Animation", forState: .Normal)
        backgroundButton.addTarget(self, action: #selector(ButtonViewController.BackgroundAnimation(_:)), forControlEvents: .TouchUpInside)
        backgroundButton.animationType = .background
        backgroundButton.startAnimation()
        self.view.addSubview(backgroundButton)
        
        textButton.setTitle("Text Animation", forState: .Normal)
        textButton.backgroundColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        textButton.animationTextColor = UIColor.whiteColor()
        textButton.addTarget(self, action: #selector(ButtonViewController.textAnimation(_:)), forControlEvents: .TouchUpInside)
        textButton.animationType = .text
        textButton.startAnimation()
        self.view.addSubview(textButton)
        
        rippleButton.setTitle("Ripple Animation", forState: .Normal)
        rippleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rippleButton.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        rippleButton.addTarget(self, action: #selector(ButtonViewController.rippleAnimation(_:)), forControlEvents: .TouchUpInside)
        rippleButton.animationType = .ripple
        rippleButton.startAnimation()
        self.view.addSubview(rippleButton)
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
