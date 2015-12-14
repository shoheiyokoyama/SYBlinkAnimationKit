//
//  LabelViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 2015/12/13.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class LabelViewController: UIViewController {
    
    let borderLabel = SYLabel()
    let border2Label = SYLabel()
    let backgroundLabel = SYLabel()
    let textLabel = SYLabel()
    let rippleLabel = SYLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.borderLabel.frame = CGRectMake(40, 50, 300, 50)
        self.borderLabel.text = "Border Animation"
        self.borderLabel.layer.cornerRadius = 5.0 // TODO: Animation の挙動が変わる
        self.borderLabel.animationBorderColor = UIColor.redColor()
        self.borderLabel.syLabelAnimation = .Border
        self.borderLabel.startAnimation()
        self.view.addSubview(self.borderLabel)
        
        self.border2Label.frame = CGRectMake(40, 110, 300, 50)
        self.border2Label.text = "BorderWithLight Animation"
        self.border2Label.layer.cornerRadius = 5.0 // TODO: Animation の挙動が変わる
        self.border2Label.animationBorderColor = UIColor.blueColor()
        self.border2Label.syLabelAnimation = .BorderWithLight
        self.border2Label.startAnimation()
        self.view.addSubview(self.border2Label)
        
        self.backgroundLabel.frame = CGRectMake(40, 170, 300, 50)
        self.backgroundLabel.text = "Background Animation"
        self.backgroundLabel.animationBackgroundColor = UIColor.yellowColor()
        self.backgroundLabel.syLabelAnimation = .Background
        self.backgroundLabel.startAnimation()
        self.view.addSubview(self.backgroundLabel)
        
        self.textLabel.frame = CGRectMake(40, 230, 300, 50)
        self.textLabel.text = "Text Animation"
        self.textLabel.animationTextColor = UIColor.greenColor()
        self.textLabel.syLabelAnimation = .Text
        self.textLabel.startAnimation()
        self.view.addSubview(self.textLabel)
        
        self.rippleLabel.frame = CGRectMake(40, 290, 300, 50)// TODO: Animation Time, Size
        self.rippleLabel.text = "Ripple Animation"
        self.rippleLabel.animationRippleColor = UIColor.orangeColor()
        self.rippleLabel.syLabelAnimation = .Ripple
        self.rippleLabel.startAnimation()
        self.view.addSubview(self.rippleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
