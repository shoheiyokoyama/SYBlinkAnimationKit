//
//  TextConvertible.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/27.
//
//

import UIKit

public enum TextPosition {
    case topLeft, topCenter, topRight
    case left, center, right
    case bottomLeft, bottomCenter, bottomRight
}

protocol TextConvertible {
    var textLayer: CATextLayer { get set }
    var textPosition: TextPosition { get set }
    
    func configureTextLayer(text: String?, font: UIFont?, textColor: UIColor)
}

extension TextConvertible where Self: UIView {
    func configureTextLayer(text: String?, font: UIFont?, textColor: UIColor) {
        guard let text = text, font = font else { return }
        
        var attributes = [String: AnyObject]()
        attributes[NSFontAttributeName] = font
        
        let size   = text.sizeWithAttributes(attributes)
        let origin = textPoint(size)
        let frame  = CGRect(origin: origin, size: CGSize(width: size.width, height: size.height + layer.borderWidth))
        
        textLayer.font            = font
        textLayer.string          = text
        textLayer.fontSize        = font.pointSize
        textLayer.foregroundColor = textColor.CGColor
        textLayer.contentsScale   = UIScreen.mainScreen().scale
        textLayer.frame           = frame
    }
    
    private func textPoint(size: CGSize) -> CGPoint {
        let horizonalCenter = ( self.frame.width - size.width ) / 2
        let horizonalRight = self.frame.width - size.width
        let verticalCenter  = ( self.frame.height - size.height ) / 2
        let verticalBottom  = self.frame.height - size.height
        
        switch textPosition {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .topCenter:
            return CGPoint(x: horizonalCenter, y: 0)
        case .topRight:
            return CGPoint(x: horizonalRight, y: 0)
        case .left:
            return CGPoint(x: 0, y: verticalCenter)
        case .center:
            return CGPoint(x: horizonalCenter, y: verticalCenter)
        case .right:
            return CGPoint(x: horizonalRight, y: verticalCenter)
        case .bottomLeft:
            return CGPoint(x: 0, y: verticalBottom)
        case .bottomCenter:
            return CGPoint(x: horizonalCenter, y: verticalBottom)
        case .bottomRight:
            return CGPoint(x: horizonalRight, y: verticalBottom)
        }
    }
}

