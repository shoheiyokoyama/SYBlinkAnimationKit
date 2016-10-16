//
//  TextFieldViewController.swift
//  SYBlinkAnimationKit
//
//  Created by Shoehi Yokoyama on 2015/12/13.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class TextFieldViewController: UIViewController {
    
    @IBOutlet private weak var borderTextField: SYTextField!
    @IBOutlet private weak var border2TextField: SYTextField!
    @IBOutlet private weak var backgrondTextField: SYTextField!
    @IBOutlet private weak var rippleTextField: SYTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "SYTextField"
        
        borderTextField.placeholder = "Border Animation"
        borderTextField.delegate = self
        borderTextField.startAnimating()
        view.addSubview(borderTextField)
        
        border2TextField.placeholder = "BorderWithShadow Animation"
        border2TextField.delegate = self
        border2TextField.animationType = .borderWithShadow
        border2TextField.backgroundColor = .clear
        border2TextField.startAnimating()
        view.addSubview(border2TextField)
        
        backgrondTextField.placeholder = "Background Animation"
        backgrondTextField.delegate = self
        backgrondTextField.animationType = .background
        backgrondTextField.startAnimating()
        view.addSubview(backgrondTextField)
        
        rippleTextField.placeholder = "Ripple Animation"
        rippleTextField.delegate = self
        rippleTextField.animationType = .ripple
        rippleTextField.startAnimating()
        view.addSubview(rippleTextField)
    }
}

//MARK: - UITextFieldDelegate

extension TextFieldViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
