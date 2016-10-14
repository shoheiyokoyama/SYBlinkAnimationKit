//
//  TextFieldViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shoehi Yokoyama on 2015/12/13.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class TextFieldViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var borderTextField: SYTextField!
    @IBOutlet weak var border2TextField: SYTextField!
    @IBOutlet weak var backgrondTextField: SYTextField!
    @IBOutlet weak var rippleTextField: SYTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "SYTextField"
        
        borderTextField.placeholder = "Border Animation"
        borderTextField.delegate = self
        borderTextField.startAnimation()
        view.addSubview(borderTextField)

        border2TextField.placeholder = "BorderWithShadow Animation"
        border2TextField.delegate = self
        border2TextField.animationType = .borderWithShadow
        border2TextField.backgroundColor = UIColor.clear
        border2TextField.startAnimation()
        view.addSubview(border2TextField)

        backgrondTextField.placeholder = "Background Animation"
        backgrondTextField.delegate = self
        backgrondTextField.animationType = .background
        backgrondTextField.startAnimation()
        view.addSubview(backgrondTextField)
        
        rippleTextField.placeholder = "Ripple Animation"
        rippleTextField.delegate = self
        rippleTextField.animationType = .ripple
        rippleTextField.startAnimation()
        view.addSubview(rippleTextField)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
