//
//  UBaseCollectionViewCell.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/11.
//  Copyright © 2020 LEPU. All rights reserved.
/*
 
 所有的 CollectionViewCell 的父类
 
 */

import UIKit
import Reusable //需要使用Reusable对cell进行获取和注册,则需要cell遵从Reusable协议

class UBaseCollectionViewCell: UICollectionViewCell , Reusable{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //一个对外的接口,进行UI设置
    open func configUI(){
        
    }
    
}
