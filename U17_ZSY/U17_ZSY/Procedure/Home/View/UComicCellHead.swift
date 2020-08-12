//
//  UComicCellHead.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/11.
//  Copyright © 2020 LEPU. All rights reserved.
//

import UIKit

class UComicCellHead: UBaseCollectionReusableView {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        
        imgV.contentMode = .scaleAspectFit
        
        
        return imgV
    }()
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("•••", for: .normal)
        $0.setTitleColor(UIColor.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
    }
    
    @objc func moreAction(button: UIButton) {
//        delegate?.comicCHead(self, moreAction: button)
//
//        guard let closure = moreActionClosure else { return }
//        closure()
        print("按钮点击")
    }
    
    override func configUI() {
        
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(5)
            $0.centerY.height.equalTo(iconView)
            $0.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
    }
    
}
