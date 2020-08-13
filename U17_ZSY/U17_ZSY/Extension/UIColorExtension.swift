//
//  UIColorExtension.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

extension UIColor {
    /**
    convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
    便利构造函数通常用在对系统的类进行构造函数的扩充时使用。
    便利构造函数的特点：
    1、便利构造函数通常都是写在extension里面
    2、便利函数init前面需要加载convenience
    3、在便利构造函数中需要明确的调用self.init()
    
    */
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
    
    //颜色转图片
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)//获取上下文
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

