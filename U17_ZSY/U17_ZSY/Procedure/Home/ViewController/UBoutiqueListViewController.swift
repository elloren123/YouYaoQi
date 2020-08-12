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
    //MARK: - 属性
    private var sexType : Int  = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    
    private var galleryItems = [GalleryItemModel]() //这个是轮播的数据模型
    
    private var TextItems = [TextItemModel]()
    
    private var comicLists = [ComicListModel]()
    
    //MARK: - 懒加载
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10 //网格中各行项目之间使用的最小间距
        layout.minimumInteritemSpacing = 5 //同一行中各项之间使用的最小间距
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self //之前忘记了这个代理,导致UIScrollViewDelegate不走🤣🤣🤣
//        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        //原始注册方式
        //collectionView.register(UComicCell.self, forCellWithReuseIdentifier: UComicCellID)
        //第三方注册方式
        collectionView.register(cellType: UComicCell.self)
        collectionView.register(cellType: UBoardCCell.self)
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
    
    //男生女生Btn
    private lazy var sexTypeButton = UIButton().then {
        $0.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
    }
    
    //MARK: - 系统构造函数
    override func viewDidLoad() {
        super.viewDidLoad()
        print("推荐")
        view.backgroundColor = UIColor.white
        setupUI()
        loadData(false)
    }
    
    //男生女生Btn Action
    @objc private func changeSex() {
        loadData(true)
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
        
        view.addSubview(sexTypeButton)
        sexTypeButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.height.equalTo(60)
        }
        
        
    }
}

//MARK: - 数据源请求
extension UBoutiqueListViewController {
    func loadData(_ changeSex:Bool){
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            //发送通知
            NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
        }
        
        sexTypeButton.setImage(UIImage(named: sexType == 1 ? "gender_male" : "gender_female"),
        for: .normal)
        
        ApiLoadingProvider.request(UApi.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) {[weak self] (returnData) in
            //这里返回的returnData为BoutiqueListModel类型
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.TextItems = returnData?.textItems ?? []
            self?.comicLists = returnData?.comicLists ?? []
            
            self?.collectionView.reloadData() //刷新
            
            //遍历galleryItems 数组,去除cover= nil的数据,遍历返回一个只有cover的数组
            self?.bannerView.imagePaths = self?.galleryItems.filter{ $0.cover != nil }.map{ $0.cover! } ?? []
            
        }
        
    }
    
}



//MARK: - collectionView代理
extension UBoutiqueListViewController : UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        /*
         取数组中的前4个,如果不足4个,则获得整个数组,如果大于4个,则取前四
         */
        
        return comicList.comics?.prefix(4).count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UBoardCCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCell.self)
            if comicList.comicType == .thematic {
                cell.style = .none
            } else {
                cell.style = .withTitleAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0) //可以小,但是不能大,所以向下取值
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                //两个cell一排的
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                /*
                 这个是一般的cell的大小
                 如果是1个数据--> width = 1/3
                 如果是2个数据--> width = 1/2
                 如果是3个数据--> width = 1/3
                 如果是4个及以上数据--> width = 1/2
                 */
                let count = comicList.comics?.prefix(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension UBoutiqueListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //一开始的原点,就是一个负值 -175
        if scrollView == collectionView {
            //让banner和collectionview同时滑动
            //对应布局而言,左上角是 0 ,但是对应滑动时的坐标点,一开始是 -175
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


