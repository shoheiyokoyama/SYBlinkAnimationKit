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
    
    @IBOutlet weak var borderView: SYView!
    @IBOutlet weak var border2View: SYView!
    @IBOutlet weak var backgrondView: SYView!
    @IBOutlet weak var rippleView: SYView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "SYView"
        
        borderView.startAnimating()
        self.view.addSubview(borderView)
        
        border2View.animationType = .borderWithShadow
        border2View.backgroundColor = UIColor.clear
        border2View.startAnimating()
        self.view.addSubview(border2View)
        
        backgrondView.animationType = .background
        backgrondView.startAnimating()
        self.view.addSubview(backgrondView)
        
        rippleView.animationType = .ripple
        rippleView.startAnimating()
        self.view.addSubview(rippleView)
    }
}
