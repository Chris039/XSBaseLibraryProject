//
//  UIColor+Extension.swift
//  XSBaseLibraryProject
//
//  Created by chris lee on 2021/7/13.
//  Copyright © 2021年 chris lee. All rights reserved.
//

import UIKit

#if os(iOS) || os(tvOS)
    import UIKit
    typealias SWColor = UIColor
#else
    import Cocoa
    typealias SWColor = NSColor
#endif

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

public extension SWColor {
    
    /// 随机颜色
    class var randomColor: UIColor {
        get {
            let red   = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue  = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 通过16进制设置颜色
    ///
    /// - Parameters:
    ///     - hexString: 6位16进制数，不带 #
    ///     - alpha: 透明度，默认透明度为1
    convenience init?(hexString: String, alpha: Float = 1.0) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            self.init()
            return nil
        }
    }
    
    private convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
}

