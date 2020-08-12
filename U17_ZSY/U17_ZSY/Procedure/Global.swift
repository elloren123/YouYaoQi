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

//获取当前APP是否加载了VC,有则获取当前的这个顶层VC
var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}
private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        //UINavigationController的栈顶VC
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}



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

//MARK: UserDefaults存储数据的Key值
extension String {
    static let searchHistoryKey = "searchHistoryKey" //搜索历史
    static let sexTypeKey = "sexTypeKey"             //选择的性别
}


//MARK: 通知Name
extension NSNotification.Name {
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
}

