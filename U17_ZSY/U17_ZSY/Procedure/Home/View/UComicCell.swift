//
//  UComicCell.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/11.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit
import Reusable

enum UComicCellStyle {
    case none                 //没有 titile 和 desc
    case withTitle            //只有title
    case withTitleAndDesc     //都有
}

class UComicCell: UBaseCollectionViewCell {
    
    //MARK: - 懒加载属性
    private lazy var iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFill //铺满
        $0.clipsToBounds = true //子视图是否被限制在视图的边界内
        $0.image = UIImage(named: "normal_placeholder_h")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "史上最强有脚气大侠"
    }
    
    private lazy var descLabel = UILabel().then{
        $0.textColor = UIColor.gray
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "少女 柔情 暖暖 香香"
    }
    
    //MARK: - 重写configUI
    override func configUI() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            //距离左右边距各10
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(25)
            //这里先默认是距底部10,后面根据需求进行动态调整
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
    }
    
    //MARK: - 对外属性
    //用于调整是否显示title和 desc
    var style : UComicCellStyle = .withTitle {
        didSet{
            switch style {
            case .none:
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(25) //它的调整是为了img可以覆盖整个cell
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
            case .withTitle:
                titleLabel.snp.updateConstraints{
                    $0.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
            case .withTitleAndDesc:
                titleLabel.snp.updateConstraints{
                    $0.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
            }
        }
    }
    //用于给cell赋值
    var model : ComicModel? {
        didSet{
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover ,placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
        }
        
    }
    
}
