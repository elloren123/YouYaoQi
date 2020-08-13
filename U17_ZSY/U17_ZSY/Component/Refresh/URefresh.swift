//
//  URefresh.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/13.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var uHead: MJRefreshHeader {
        get { return mj_header! }
        set { mj_header = newValue }
    }
    
    var uFoot: MJRefreshFooter {
        get { return mj_footer! }
        set { mj_footer = newValue }
    }
}

class URefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle) //刷新开始前的图片
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling) //将要开始刷新
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing) //刷新过程中的图片动画
        
        lastUpdatedTimeLabel!.isHidden = true //刷新时间隐藏
        stateLabel!.isHidden = true //刷新状态隐藏
    }
}

class URefreshAutoHeader: MJRefreshHeader {}

class URefreshFooter: MJRefreshBackNormalFooter {}

class URefreshAutoFooter: MJRefreshAutoFooter {}


class URefreshDiscoverFooter: MJRefreshBackGifFooter {
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.background
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel!.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}

class URefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.background
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}


