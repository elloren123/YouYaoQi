//
//  UIBarButtonItemExtension.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(image:UIImage?,target:Any?,action:Selector?){
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        //修正btn的大小
        button.sizeToFit()
        if button.bounds.width < 40 || button.bounds.height > 40 {
            let width = 40 / button.bounds.height * button.bounds.width;
            button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
        }
        
        self.init(customView:button)
    }
    
}
