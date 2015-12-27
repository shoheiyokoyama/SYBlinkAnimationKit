//
//  TextFieldViewViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shoehi Yokoyama on 2015/12/13.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class TextFieldViewViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellowColor()
        
        let borderTextField = SYTextField(frame: CGRectMake(40, 50, 300, 50))
        borderTextField.delegate = self
//        borderTextField.syTextFieldAnimation = .Border
//        borderTextField.animationBorderColor = UIColor.redColor()
        borderTextField.backgroundColor = UIColor.clearColor()
        borderTextField.startAnimation()
        self.view.addSubview(borderTextField)
        
        let border2TextField = SYTextField(frame: CGRectMake(40, 110, 300, 50))
        border2TextField.delegate = self
        border2TextField.syTextFieldAnimation = .BorderWithShadow
//        border2TextField.animationBorderColor = UIColor.redColor()
//        border2TextField.backgroundColor = UIColor.clearColor()
        border2TextField.startAnimation()
        self.view.addSubview(border2TextField)
//
        let rippleTextField = SYTextField(frame: CGRectMake(40, 170, 300, 50))
        rippleTextField.delegate = self
        rippleTextField.syTextFieldAnimation = .Ripple
//        rippleTextField.animationRippleColor = UIColor.purpleColor()
        rippleTextField.startAnimation()
        view.addSubview(rippleTextField)
        
        // TODO: List
//            ・animation on off の挙動確認
//            ・UITextFieldのスタイル見直し
//            ・backgroundColorどうする
//                ・タップしたとき色変えてるかもset backgroundColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
