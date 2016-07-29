//
//  SYAnimation.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/29.
//
//

import UIKit

extension CABasicAnimation {
    convenience init(type: AnimationKeyType) {
        self.init(keyPath: type.rawValue)
    }
}
