//
//  UIColorExt.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/10.
//

import UIKit
extension UIColor {
    /**
     This function translates color from hexa-code to an RGB value
     - Parameter rgbValue: the hexacode value where the desired color is encoded
     - Parameter alpha: the degree of transluency with a value from 0 to 1, where 1 represents the most solid color
     - Returns: the color stored in UIColor format
     */
    class func fromHexColor(rgbValue: UInt32, alpha: Double = 1.0)->UIColor {
        let red   = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
