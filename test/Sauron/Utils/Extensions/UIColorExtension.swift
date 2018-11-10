//
//  UIColorExtension.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /**
     wrapper for [UIColor colorWithRed:green:blue:alpha:]
     @param  : values must be in range 0 - 255
     */
    class func with8BitRed(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: (red/255.0), green: (green/255.0), blue: (blue/255.0), alpha: alpha)
    }
    
    /**
     create colour from colour hex code like : #2354af
     @param  : value must begin with # and also have 7 characters
     */
    convenience init(hex: String, alpha: CGFloat) {
        assert(7 == hex.count)
        assert(hex.hasPrefix("#"))
        
        let redHex: String = "0x\((hex as NSString).substring(with: NSRange(location: 1, length: 2)))"
        let greenHex: String = "0x\((hex as NSString).substring(with: NSRange(location: 3, length: 2)))"
        let blueHex: String = "0x\((hex as NSString).substring(with: NSRange(location: 5, length: 2)))"
        var redInt: UInt32 = 0
        let rScanner = Scanner(string: redHex)
        rScanner.scanHexInt32(&redInt)
        var greenInt: UInt32 = 0
        let gScanner = Scanner(string: greenHex)
        gScanner.scanHexInt32(&greenInt)
        var blueInt: UInt32 = 0
        let bScanner = Scanner(string: blueHex)
        bScanner.scanHexInt32(&blueInt)
        self.init(red: CGFloat(redInt) / 255, green: CGFloat(greenInt) / 255, blue: CGFloat(blueInt) / 255, alpha: alpha)
    }
    
    class func error() -> UIColor {
        return UIColor.with8BitRed(213, green: 0, blue: 0, alpha: 1.0)
    }
    
    class func peacockBlue() -> UIColor {
        return UIColor.with8BitRed(0, green: 85, blue: 183, alpha: 1.0)
    }
    
    class func textPlaceholder() -> UIColor {
        return UIColor.with8BitRed(176, green: 176, blue: 176, alpha: 1.0)
    }
    
    class func greySeparator() -> UIColor {
        return UIColor.with8BitRed(220, green: 220, blue: 220, alpha: 1.0)
    }
    
}

