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
        borderLabel.layer.cornerRadius = 5.0 // TODO: Animation の挙動が変わる
//        borderLabel.animationBorderColor = UIColor.redColor()
        borderLabel.syLabelAnimation = .Border
        borderLabel.startAnimation()
        self.view.addSubview(borderLabel)
        
        let border2Label = SYLabel(frame: CGRectMake(40, 110, 300, 50))
        border2Label.text = "BorderWithShadow Animation"
        border2Label.layer.cornerRadius = 5.0 // TODO: Animation の挙動が変わる
//        border2Label.animationBorderColor = UIColor.blueColor()
        border2Label.syLabelAnimation = .BorderWithShadow
        border2Label.startAnimation()
        self.view.addSubview(border2Label)
        
        let backgroundLabel = SYLabel(frame: CGRectMake(40, 170, 300, 50))
        backgroundLabel.text = "Background Animation"
//        backgroundLabel.animationBackgroundColor = UIColor.yellowColor()
        backgroundLabel.syLabelAnimation = .Background
        backgroundLabel.startAnimation()
        self.view.addSubview(backgroundLabel)
        
        let textLabel = SYLabel(frame: CGRectMake(40, 230, 300, 50))
        textLabel.text = "Text Animation"
//        textLabel.animationTextColor = UIColor.greenColor()
        textLabel.syLabelAnimation = .Text
        textLabel.startAnimation()
        self.view.addSubview(textLabel)
        
        let rippleLabel = SYLabel(frame: CGRectMake(40, 290, 300, 50))// TODO: Animation Time, Size
        rippleLabel.text = "Ripple Animation"
        rippleLabel.labelColor = UIColor.grayColor()
//        rippleLabel.animationRippleColor = UIColor.orangeColor()
        rippleLabel.syLabelAnimation = .Ripple
        rippleLabel.startAnimation()
        self.view.addSubview(rippleLabel)
                
        
        
        
        //animation on off の挙動確認
        //time,functionのプロパティ
        //テスト
//        ・文字変更
//        ・サイズ変更
//        ・frame変更
//        ・フォント変更
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
