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
        borderLabel.syLabelAnimation = .Border
        borderLabel.startAnimation()
        self.view.addSubview(borderLabel)
        
        let border2Label = SYLabel(frame: CGRectMake(40, 110, 300, 50))
        border2Label.text = "BorderWithShadow Animation"
        border2Label.animationBorderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        border2Label.backgroundColor = UIColor.clearColor()
        border2Label.layer.masksToBounds = true
        border2Label.syLabelAnimation = .BorderWithShadow
        border2Label.startAnimation()
        self.view.addSubview(border2Label)
        
        let backgroundLabel = SYLabel(frame: CGRectMake(40, 170, 300, 50))
        backgroundLabel.text = "Background Animation"
        backgroundLabel.syLabelAnimation = .Background
        backgroundLabel.startAnimation()
        self.view.addSubview(backgroundLabel)
        
        let textLabel = SYLabel(frame: CGRectMake(40, 230, 300, 50))
        textLabel.text = "Text Animation"
        textLabel.syLabelAnimation = .Text
        textLabel.startAnimation()
        self.view.addSubview(textLabel)
        
        let rippleLabel = SYLabel(frame: CGRectMake(40, 290, 300, 50))
        rippleLabel.text = "Ripple Animation"
        rippleLabel.backgroundColor = UIColor.blackColor()
        rippleLabel.labelTextColor = UIColor.whiteColor()
        rippleLabel.syLabelAnimation = .Ripple
        rippleLabel.startAnimation()
        self.view.addSubview(rippleLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
