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
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "SYButton"
        
        borderButton.setTitle("Border Animation", for: UIControlState())
        borderButton.addTarget(self, action: #selector(ButtonViewController.borderAnimation(_:)), for: .touchUpInside)
        borderButton.startAnimation()
        self.view.addSubview(borderButton)
        
        border2Button.setTitle("BorderWithShadow Animation", for: UIControlState())
        border2Button.animationBorderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        border2Button.addTarget(self, action: #selector(ButtonViewController.BorderWithShadowAnimation(_:)), for: .touchUpInside)
        border2Button.animationType = .borderWithShadow
        border2Button.startAnimation()
        self.view.addSubview(border2Button)
        
        backgroundButton.setTitle("Background Animation", for: UIControlState())
        backgroundButton.addTarget(self, action: #selector(ButtonViewController.BackgroundAnimation(_:)), for: .touchUpInside)
        backgroundButton.animationType = .background
        backgroundButton.startAnimation()
        self.view.addSubview(backgroundButton)
        
        textButton.setTitle("Text Animation", for: UIControlState())
        textButton.backgroundColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        textButton.animationTextColor = UIColor.white
        textButton.addTarget(self, action: #selector(ButtonViewController.textAnimation(_:)), for: .touchUpInside)
        textButton.animationType = .text
        textButton.startAnimation()
        self.view.addSubview(textButton)
        
        rippleButton.setTitle("Ripple Animation", for: UIControlState())
        rippleButton.setTitleColor(UIColor.white, for: UIControlState())
        rippleButton.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        rippleButton.addTarget(self, action: #selector(ButtonViewController.rippleAnimation(_:)), for: .touchUpInside)
        rippleButton.animationType = .ripple
        rippleButton.startAnimation()
        self.view.addSubview(rippleButton)
    }
    
    // MARK: - SYButton Tap Events -
    
    internal func borderAnimation(_ sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BorderWithShadowAnimation(_ sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func BackgroundAnimation(_ sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func textAnimation(_ sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
    
    internal func rippleAnimation(_ sender: SYButton) {
        sender.isAnimating ? sender.stopAnimation() : sender.startAnimation()
    }
}
