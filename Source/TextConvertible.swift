//
//  TextConvertible.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/27.
//
//

import UIKit

protocol TextConvertible {
    var textLayer: CATextLayer { get set }
    
    func configureTextLayer(text: String?, font: UIFont?, textColor: UIColor)
}

extension TextConvertible where Self: UIView {
    func configureTextLayer(text: String?, font: UIFont?, textColor: UIColor) {
        guard let text = text, font = font else { return }
        
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        
        let size  = text.sizeWithAttributes(attributes)
        let x     = ( self.frame.width - size.width ) / 2
        let y     = ( self.frame.height - size.height ) / 2
        let frame = CGRect(x: x, y: y, width: size.width, height: size.height + layer.borderWidth)
        
        textLayer.font            = font
        textLayer.string          = text
        textLayer.fontSize        = font.pointSize
        textLayer.foregroundColor = textColor.CGColor
        textLayer.contentsScale   = UIScreen.mainScreen().scale
        textLayer.frame           = frame
        textLayer.alignmentMode   = kCAAlignmentCenter
    }
}

