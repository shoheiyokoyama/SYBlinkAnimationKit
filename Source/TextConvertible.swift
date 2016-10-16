//
//  TextConvertible.swift
//  Pods
//
//  Created by Shohei Yokoyama on 2016/07/27.
//
//

import UIKit

public enum TextAlignmentMode {
    case topLeft, topCenter, topRight
    case left, center, right
    case bottomLeft, bottomCenter, bottomRight
}

protocol TextConvertible {
    var textLayer: CATextLayer { get set }
    var textAlignmentMode: TextAlignmentMode { get set }
    
    func configureTextLayer(_ text: String?, font: UIFont?, textColor: UIColor)
}

extension TextConvertible where Self: UIView {
    func configureTextLayer(_ text: String?, font: UIFont?, textColor: UIColor) {
        guard let text = text, let font = font else { return }
        
        let attributes = [NSFontAttributeName: font]
        
        let size   = text.size(attributes: attributes)
        let origin = textPoint(ofSize: size)
        let frame  = CGRect(origin: origin, size: CGSize(width: size.width, height: size.height + layer.borderWidth))
        
        textLayer.font            = font
        textLayer.string          = text
        textLayer.fontSize        = font.pointSize
        textLayer.foregroundColor = textColor.cgColor
        textLayer.contentsScale   = UIScreen.main.scale
        textLayer.frame           = frame
        textLayer.alignmentMode   = alignmentMode
    }
    
    // MARK: - Private Methods -
    
    private var alignmentMode: String {
        switch textAlignmentMode {
        case .left, .topLeft, .bottomLeft:       return "left"
        case .center, .topCenter, .bottomCenter: return "center"
        case .right, .topRight, .bottomRight:    return "right"
        }
    }
    
    private func textPoint(ofSize size: CGSize) -> CGPoint {
        let horizonalCenter = ( self.frame.width - size.width ) / 2
        let horizonalRight  = self.frame.width - size.width
        let verticalCenter  = ( self.frame.height - size.height ) / 2
        let verticalBottom  = self.frame.height - size.height
        
        switch textAlignmentMode {
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

