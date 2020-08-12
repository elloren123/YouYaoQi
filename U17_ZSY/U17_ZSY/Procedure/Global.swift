//
//  Global.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/11.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

//MARK: - 第三方
//使用@_exported import关键字导入第三方库,可以全局通用
@_exported import SnapKit             //布局
@_exported import Then                //初始化
@_exported import Kingfisher          //图片加载

//MARK: - 常量
let screenWidth = UIScreen.main.bounds.width
let screenHeigth = UIScreen.main.bounds.height


//MARK: - 一些扩展方法

//MARK: 图片加载
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?,
                         placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask{
        setImage(with: URL(string: urlString ?? ""), placeholder: placeholder, options: [.transition(.fade(0.5))])
        /*
         options:这里添加一个动画,在加载时淡入
         */
    }
    
}
extension Kingfisher where Base: Button {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
        
    }
}

//MARK: 颜色
extension UIColor {
    //默认的背景色
    class var background: UIColor {
        return UIColor(R: 242, G: 242, B: 242)
    }
    //默认的主题颜色
    class var theme: UIColor {
        return UIColor(R: 29, G: 221, B: 43)
    }
}
