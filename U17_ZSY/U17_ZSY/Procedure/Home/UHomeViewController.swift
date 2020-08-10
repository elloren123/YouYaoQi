//
//  UHomeViewController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit
import HMSegmentedControl  //第三方segment控件
import SnapKit             //布局
import Then                //初始化
import Reusable            //Cell的注册和重用
import Kingfisher          //图片加载

class UHomeViewController: UIViewController {
    //MARK: - 懒加载
    lazy var segment:HMSegmentedControl = {
        /*这个是原始的懒加载初始化方法
        let segmentC = HMSegmentedControl()
        segmentC.addTarget(self, action: #selector(changeIndex(segment:)), for: .valueChanged)
        return segmentC
         */
        return HMSegmentedControl().then{
            $0.addTarget(self, action: #selector(changeIndex(segment:)), for: .valueChanged)
        }
    }()
    
    /*
     UIPageViewController
     1. 会预加载下一个界面,第一个除外
     2. 滑动时,如果添加动画,从第n个直接到第m个,动画是直接滑动,不会出现中间的n~m间的vc
     */
    lazy var pageVC:UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    //pageVC的子界面
    private let vcs:[UIViewController] = [UBoutiqueListViewController(),
                                  UVIPListViewController(),
                                  USubscibeListViewController(),
                                  URankListViewController()]
    //segment的标题
    private let titles:[String] = ["推荐",
                                   "VIP",
                                   "订阅",
                                   "排行"]
    //当前的位置-->segment和pageVC的联动
    private var currentSelectIndex:Int = 0
    
    //MARK: - 系统构造函数
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        //导航栏遮挡问题修正
        if #available(iOS 11.0, *){
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
        setNav()
    }
    
    //MARK: - segment事件
    @objc func changeIndex(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        if index != currentSelectIndex {
            //进行移动,方向判断
            //setViewControllers不会触发预加载
            let direction:UIPageViewController.NavigationDirection = currentSelectIndex > index ? .reverse : .forward
            pageVC.setViewControllers([vcs[index]], direction: direction, animated: true) { (finish) in
                self.currentSelectIndex = index
            }
        }
    }
    
    @objc func backBtnClick(){
        
    }
    @objc func selectAction(){
        
    }

}

//MARK: - UI
extension UHomeViewController {
    func setupUI(){
        //设置pageVC
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)
        pageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        //设置segment
        segment.backgroundColor = UIColor.clear
        segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        segment.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        segment.selectionIndicatorLocation = .none
        navigationItem.titleView = segment
        segment.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 120, height: 40)
        segment.sectionTitles = titles
        segment.selectedSegmentIndex = UInt(currentSelectIndex)
    }
    //设置导航栏
    func setNav(){
        guard let nav = navigationController else {
            return
        }
        //visibleViewController:导航界面中与当前可见视图相关联的视图控制器
        if nav.visibleViewController == self {
            //背景
            nav.navigationBar.barStyle = .black
            nav.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            //返回按钮
            if nav.viewControllers.count > 1 {
               navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                  target: self,
                                                                  action: #selector(backBtnClick))
            }
            //搜索🔍 -->系统的,显示很丑,重写一个
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                                target: self,
                                                                action: #selector(selectAction))
            
        }
        
    }
    
}

extension UHomeViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil } //获取当前的VC在哪个位置
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else { return nil }
        return vcs[beforeIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil } //获取当前的VC在哪个位置
        let afterIndex = index + 1
        guard afterIndex <= vcs.count - 1 else { return nil }
        return vcs[afterIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //获取当前的VC和位置
        guard let currentVC = pageViewController.viewControllers?.last , let index = vcs.firstIndex(of: currentVC) else {
            return
        }
        currentSelectIndex = index
        segment.setSelectedSegmentIndex(UInt(index), animated: false)
        
    }
    
    
}
