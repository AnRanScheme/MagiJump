//
//  UIColor+extension.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func randomColor() -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    
}
