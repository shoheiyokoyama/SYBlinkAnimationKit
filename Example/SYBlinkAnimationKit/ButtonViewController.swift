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
    
    let borderButton = SYButton(frame: CGRectMake(40, 100, 300, 50))
    let border2Button = SYButton(frame: CGRectMake(40, 160, 300, 50))
    let backgroundButton = SYButton(frame: CGRectMake(40, 220, 300, 50))
    let textButton = SYButton(frame: CGRectMake(40, 280, 300, 50))
    let rippleButton = SYButton(frame: CGRectMake(40, 340, 300, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "SYButton"
        
        borderButton.setTitle("SYLabel", forState: .Normal)
        borderButton.addTarget(self, action: #selector(ButtonViewController.borderAnimation(_:)), forControlEvents: .TouchUpInside)
        borderButton.startAnimation()
        self.view.addSubview(borderButton)
        
        border2Button.setTitle("SYTextField", forState: .Normal)
        border2Button.animationBorderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        border2Button.addTarget(self, action: #selector(ButtonViewController.BorderWithShadowAnimation(_:)), forControlEvents: .TouchUpInside)
        border2Button.animationType = .borderWithShadow
        border2Button.startAnimation()
        self.view.addSubview(border2Button)
        
        backgroundButton.setTitle("SYView", forState: .Normal)
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
        rippleButton.backgroundColor = UIColor.blackColor()
        rippleButton.addTarget(self, action: #selector(ButtonViewController.rippleAnimation(_:)), forControlEvents: .TouchUpInside)
        rippleButton.animationType = .ripple
        rippleButton.startAnimation()
        self.view.addSubview(rippleButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        borderButton.startAnimation()
        border2Button.startAnimation()
        backgroundButton.startAnimation()
        textButton.startAnimation()
        rippleButton.startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SYButton Tap Events -
    internal func borderAnimation(sender: SYButton) {
        let labelViewController = LabelViewController()
        self.navigationController?.pushViewController(labelViewController, animated: true)
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BorderWithShadowAnimation(sender: SYButton) {
        let textFieldViewController = TextFieldViewController()
        self.navigationController?.pushViewController(textFieldViewController, animated: true)
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BackgroundAnimation(sender: SYButton) {
        let animationViewController = AnimationViewController()
        self.navigationController?.pushViewController(animationViewController, animated: true)
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func textAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func rippleAnimation(sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
}
