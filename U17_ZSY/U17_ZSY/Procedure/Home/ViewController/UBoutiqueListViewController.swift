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
import LLCycleScrollView


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
        layout.headerReferenceSize = CGSize(width: screenWidth, height: kHeaderH)
        layout.footerReferenceSize = CGSize(width: screenWidth, height: 10)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self //之前忘记了这个代理,导致UIScrollViewDelegate不走🤣🤣🤣
//        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        //原始注册方式
        //collectionView.register(UComicCell.self, forCellWithReuseIdentifier: UComicCellID)
        //第三方注册方式
        collectionView.register(cellType: UComicCell.self)
        
        collectionView.register(supplementaryViewType: UComicCellHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: UComicCellFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        
        return collectionView
    }()
    
    //轮播图,这里使用第三方
    private lazy var bannerView: LLCycleScrollView = {
        let bw = LLCycleScrollView()
        bw.backgroundColor =  UIColor.background
        bw.autoScrollTimeInterval = 3
        bw.placeHolderImage = UIImage(named: "normal_placeholder_h")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .right
        bw.pageControlBottom = 20
        bw.titleBackgroundColor = UIColor.clear
        bw.lldidSelectItemAtIndex = didSelectBanner(index:) //响应事件
        return bw
    }()
    
    //MARK: - 系统构造函数
    override func viewDidLoad() {
        super.viewDidLoad()
        print("推荐")
        view.backgroundColor = UIColor.white
        setupUI()
        
    }
}

//MARK: - 设置UI
extension UBoutiqueListViewController {
    func setupUI(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        collectionView.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
        
        
    }
    
}


//MARK: - collectionView代理
extension UBoutiqueListViewController : UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCell.self)
//        cell.backgroundColor = UIColor.white
        cell.style = .withTitleAndDesc
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: screenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            //这个是第三方提供的方法
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UComicCellHead.self)
            head.iconView.image = UIImage(named: "rank_frist")
            head.titleLabel.text = "劲爆小说"
            
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicCellFoot.self)
            return foot
        }
    }
}

//MARK: - UIScrollViewDelegate
extension UBoutiqueListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     print(scrollView.contentOffset.y)//一开始的原点,就是一个负值 -175
        if scrollView == collectionView {
            //让banner和collectionview同时滑动
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
    }
}


//MARK: - Action
extension UBoutiqueListViewController {
    //轮播图事件
    private func didSelectBanner(index: NSInteger) {
//        let item = galleryItems[index]
//        if item.linkType == 2 {
//            guard let url = item.ext?.compactMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
//            let vc = UWebViewController(url: url)
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            guard let comicIdString = item.ext?.compactMap({ return $0.key == "comicId" ? $0.val : nil }).joined(),
//                let comicId = Int(comicIdString) else { return }
//            let vc = UComicViewController(comicid: comicId)
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
}


