//
//  UTabBarController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

class UTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //如果你将这个属性设置为false并且背景图像不是不透明的，UIKit会添加一个不透明的背景
        tabBar.isTranslucent = false
        
        let homeVC = UHomeViewController()
        addChildViewController(homeVC, title: "首页",
                               image: UIImage(named: "tab_home"),
                               selectimage: UIImage(named: "tab_home_S"))
        
        let cateVC = UCateListViewController()
        addChildViewController(cateVC, title: "分类",
                               image: UIImage(named: "tab_class"),
                               selectimage: UIImage(named: "tab_class_S"))
        
        let bookVC = UBookViewController()
        addChildViewController(bookVC, title: "书架",
                               image: UIImage(named: "tab_book"),
                               selectimage: UIImage(named: "tab_book_S"))
        
        let mineVC = UMainViewController()
        addChildViewController(mineVC, title: "我的",
                               image: UIImage(named: "tab_mine"),
                               selectimage: UIImage(named: "tab_mine_S"))
        
        
        
    }
    
    func addChildViewController(_ childController:UIViewController,title:String?,image:UIImage?,selectimage:UIImage?){
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectimage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        let navVC = UINavigationController(rootViewController: childController)
        addChild(navVC)
    }
   
    

}
