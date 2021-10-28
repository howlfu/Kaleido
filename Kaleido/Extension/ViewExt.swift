//
//  ViewExt.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import Foundation
import UIKit
extension UIView {
    func roundedBottRight(radius: CGFloat){
            let maskPath1 = UIBezierPath(roundedRect: bounds,
                                         byRoundingCorners: [.bottomRight],
                cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = bounds
            maskLayer1.path = maskPath1.cgPath
            layer.mask = maskLayer1
    }
}
