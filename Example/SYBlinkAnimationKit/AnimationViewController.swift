//
//  AnimationViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 2016/01/16.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class AnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "SYView"
        
        let borderView = SYView(frame: CGRectMake(40, 100, 300, 100))
        borderView.startAnimation()
        self.view.addSubview(borderView)
        
        let border2View = SYView(frame: CGRectMake(40, 210, 300, 100))
        border2View.syViewAnimation = .BorderWithShadow
        border2View.backgroundColor = UIColor.clearColor()
        border2View.startAnimation()
        self.view.addSubview(border2View)
        
        let backgrondView = SYView(frame: CGRectMake(40, 320, 300, 100))
        backgrondView.syViewAnimation = .Background
        backgrondView.startAnimation()
        self.view.addSubview(backgrondView)
        
        let rippleView = SYView(frame: CGRectMake(40, 430, 300, 100))
        rippleView.syViewAnimation = .Ripple
        rippleView.startAnimation()
        self.view.addSubview(rippleView)
    }
}
