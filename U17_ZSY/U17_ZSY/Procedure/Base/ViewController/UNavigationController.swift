//
//  UNavigationController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.

/*
 
 在NavigationController堆栈内的UIViewController可以支持右滑手势，即在屏幕左边一滑，屏幕就会返回。
 但是在自定义返回按钮这个手势就会失效,以下是解决办法
 
 */

import UIKit

class UNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //处理自定义返回按钮导致侧滑的失效问题
        guard let interactionGes = interactivePopGestureRecognizer else { return } //从导航堆栈弹出顶视图控制器的手势识别器
        guard let targetView = interactionGes.view else { return } //当前的View
        
        //找到view对应的VC
        guard let internalTargets = interactionGes.value(forKeyPath: "targets") as? [NSObject] else { return }
        guard let internalTarget = internalTargets.first?.value(forKey: "target") else { return }
        
        let action = Selector(("handleNavigationTransition:")) //这个是系统的右滑返回的事件

        let fullScreenGesture = UIPanGestureRecognizer(target: internalTarget, action: action) //创建手势
        fullScreenGesture.delegate = self
        targetView.addGestureRecognizer(fullScreenGesture) //给当前的view添加上手势
        
        interactionGes.isEnabled = false //取消系统的右滑
        
    }
    
    //重写一个 pushViewController ,进行对BottomBar的统一隐藏
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
    

}

//MARK: - 手势的代理
extension UNavigationController: UIGestureRecognizerDelegate {
    
    //是否应该响应手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //一般用户界面布局流程方向
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRight ? 1 : -1) <= 0
            || disablePopGesture {
            return false
        }
        return viewControllers.count != 1;
    }
}

//想统一设置导航栏 状态视图的style
//extension UNavigationController {
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        guard let topVC = topViewController else { return .lightContent }
//        return topVC.preferredStatusBarStyle
//    }
//}


enum UNavigationBarStyle {
    case theme //绿色主题
    case clear //无
    case white //白色导航
}

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var disablePopGesture: Void?
    }
    
    //是否支持右滑返回的设置,在 👆重写的手势代理中使用到了
    var disablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.disablePopGesture) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //设置不同状态下的导航背景;
    func barStyle(_ style: UNavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
        
        
    }
}
