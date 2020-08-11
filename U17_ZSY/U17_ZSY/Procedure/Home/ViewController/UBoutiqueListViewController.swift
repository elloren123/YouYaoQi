//
//  UBoutiqueListViewController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/10.
//  Copyright © 2020 LEPU. All rights reserved.
/*
 推荐
 */

import UIKit

let kItemMargin : CGFloat = 10
let kItemW : CGFloat = (screenWidth - kItemMargin * 3)/2
let kNormalItemH : CGFloat = kItemW * 3 / 4
let kHeaderH : CGFloat = 50
let UComicCellID : String = "UComicCell"

class UBoutiqueListViewController: UIViewController {
    //MARK: - 懒加载
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0 //网格中各行项目之间使用的最小间距
        layout.minimumInteritemSpacing = kItemMargin //同一行中各项之间使用的最小间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
//        layout.headerReferenceSize = CGSize(width: screenWidth, height: kHeaderH)
//        layout.footerReferenceSize = CGSize(width: screenWidth, height: 10)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.random
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.register(UComicCell.self, forCellWithReuseIdentifier: UComicCellID)
        
        
        
        return collectionView
    }()
    
    
    //MARK: - 系统构造函数
    override func viewDidLoad() {
        super.viewDidLoad()
        print("推荐")
        view.backgroundColor = UIColor.random
        
        setupUI()
        
    }
    
    
    
}

//MARK: - 设置UI
extension UBoutiqueListViewController {
    func setupUI(){
        view.addSubview(collectionView)
        
        
    }
    
}


//MARK: - collectionView代理
extension UBoutiqueListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UComicCellID, for: indexPath) as! UComicCell
        cell.backgroundColor = UIColor.white
        cell.style = .withTitleAndDesc
        return cell
        
    }
    
}
