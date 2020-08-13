//
//  UBaseViewController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/12.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

class UBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        //设置scrollview的偏移量行为
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
         configUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    func configUI() {}
    
    func configNavigationBar() {
        //设置系统的导航栏
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
//            navi.barStyle(.theme)
//            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }


}


extension UBaseViewController {
    //调整状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
