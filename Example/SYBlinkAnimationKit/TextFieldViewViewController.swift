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
    
    let borderTextField = SYTextField()
    let border2TextField = SYTextField()
    let rippleTextField = SYTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.borderTextField.frame = CGRectMake(40, 50, 300, 50)
        self.borderTextField.delegate = self
        self.borderTextField.syTextFieldAnimation = .Border
        self.borderTextField.animationBorderColor = UIColor.redColor()
        self.borderTextField.startAnimation()
        self.view.addSubview(borderTextField)
        
        // FIXME: BorderWithShadow Animation
        self.border2TextField.frame = CGRectMake(40, 110, 300, 50)
        self.border2TextField.delegate = self
        self.border2TextField.syTextFieldAnimation = .BorderWithShadow
        self.border2TextField.animationBorderColor = UIColor.purpleColor()
        self.border2TextField.startAnimation()
        self.view.addSubview(border2TextField)
        
        self.rippleTextField.frame = CGRectMake(40, 170, 300, 50)
        self.rippleTextField.delegate = self
        self.rippleTextField.syTextFieldAnimation = .Ripple
        self.rippleTextField.animationRippleColor = UIColor.purpleColor()
        self.rippleTextField.startAnimation()
        self.view.addSubview(rippleTextField)
        
        // TODO: List
//            ・..
//            ・..
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
