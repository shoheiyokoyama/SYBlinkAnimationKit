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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let borderLabel = SYLabel(frame: CGRectMake(40, 50, 300, 50))
        borderLabel.text = "Border Animation"
        borderLabel.labelTextColor = UIColor.yellowColor()
//        borderLabel.animationBorderColor = UIColor.redColor()
        borderLabel.animationBorderColor = UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1)//Demo Color
        borderLabel.syLabelAnimation = .Border
        borderLabel.startAnimation()
//        self.view.addSubview(borderLabel)
        
        let border2Label = SYLabel(frame: CGRectMake(40, 110, 300, 50))
        border2Label.text = "BorderWithShadow Animation"
//        border2Label.animationBorderColor = UIColor.blueColor()
        border2Label.backgroundColor = UIColor.clearColor()
        border2Label.animationBorderColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1)//Demo Color
        border2Label.layer.masksToBounds = true
        border2Label.syLabelAnimation = .BorderWithShadow
        border2Label.startAnimation()
        self.view.addSubview(border2Label)
        
        let backgroundLabel = SYLabel(frame: CGRectMake(40, 170, 300, 50))
        backgroundLabel.text = "Background Animation"
//        backgroundLabel.animationBackgroundColor = UIColor.yellowColor()
        backgroundLabel.animationBackgroundColor = UIColor(red: 248/255, green: 148/255, blue: 6/255, alpha: 1)//Demo Color
        backgroundLabel.syLabelAnimation = .Background
        backgroundLabel.startAnimation()
        self.view.addSubview(backgroundLabel)
        
        let textLabel = SYLabel(frame: CGRectMake(40, 230, 300, 50))
        textLabel.text = "Text Animation"
//        textLabel.animationTextColor = UIColor.greenColor()
        textLabel.syLabelAnimation = .Text
        textLabel.animationTextColor = UIColor(red: 214/255, green: 69/255, blue: 65/255, alpha: 1)//Demo Color
        textLabel.startAnimation()
        self.view.addSubview(textLabel)
        
        let rippleLabel = SYLabel(frame: CGRectMake(40, 290, 300, 50))
        rippleLabel.text = "Ripple Animation"
        rippleLabel.backgroundColor = UIColor.blackColor()
        rippleLabel.labelTextColor = UIColor.whiteColor()
//        rippleLabel.animationRippleColor = UIColor.orangeColor()
        rippleLabel.syLabelAnimation = .Ripple
        rippleLabel.animationRippleColor = UIColor(red: 171/255, green: 183/255, blue: 183/255, alpha: 1)//Demo Color
        rippleLabel.startAnimation()
        self.view.addSubview(rippleLabel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
