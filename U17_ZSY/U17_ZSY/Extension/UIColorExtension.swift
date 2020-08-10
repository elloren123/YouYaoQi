//
//  UIColorExtension.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

extension UIColor {
    
    //MARK: RGB
    convenience init(R:CGFloat,G:CGFloat,B:CGFloat){
        self.init(red: R/255.0,
                  green: G/255.0,
                  blue: B/255.0,
                  alpha: 1)
    }
    
    //随机色
    class var random:UIColor {
        return UIColor(R: CGFloat(arc4random_uniform(256)),
                       G: CGFloat(arc4random_uniform(256)),
                       B: CGFloat(arc4random_uniform(256)))
    }
    
}

