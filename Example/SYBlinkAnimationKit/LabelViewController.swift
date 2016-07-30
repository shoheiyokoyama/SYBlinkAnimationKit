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
    
    @IBOutlet weak var borderLabel: SYLabel!
    @IBOutlet weak var border2Label: SYLabel!
    @IBOutlet weak var backgroundLabel: SYLabel!
    @IBOutlet weak var textLabel: SYLabel!
    @IBOutlet weak var rippleLabel: SYLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.title = "SYLabel"
        
        borderLabel.text = "Border Animation"
        borderLabel.animationType = .border
        borderLabel.startAnimation()
        view.addSubview(borderLabel)
        
        border2Label.text = "BorderWithShadow Animation"
        border2Label.animationBorderColor = UIColor(red: 34/255, green: 167/255, blue: 240/255, alpha: 1)
        border2Label.backgroundColor = UIColor.clearColor()
        border2Label.animationType = .borderWithShadow
        border2Label.startAnimation()
        view.addSubview(border2Label)
        
        backgroundLabel.text = "Background Animation"
        backgroundLabel.animationType = .background
        backgroundLabel.startAnimation()
        view.addSubview(backgroundLabel)
        
        textLabel.text = "Text Animation"
        textLabel.animationType = .text
        textLabel.startAnimation()
        view.addSubview(textLabel)
        
        rippleLabel.text = "Ripple Animation"
        rippleLabel.backgroundColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
        rippleLabel.labelTextColor = UIColor.whiteColor()
        rippleLabel.animationType = .ripple
        rippleLabel.startAnimation()
        view.addSubview(rippleLabel)
    }
}
