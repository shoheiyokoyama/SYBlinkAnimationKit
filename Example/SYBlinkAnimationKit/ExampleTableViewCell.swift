//
//  ExampleTableViewCell.swift
//  SYBlinkAnimationKit
//
//  Created by 横山祥平 on 2016/07/30.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import SYBlinkAnimationKit

class ExampleTableViewCell: SYTableViewCell {
    
    @IBOutlet weak var titleLabel: SYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
