//
//  UModel.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/11.
//  Copyright © 2020 LEPU. All rights reserved.
/*
 
 这里包含了所有的数据模型,以struct展示
 
 */

import HandyJSON

//整个是所有的cell需要展示的数据的model,整合到一起了,其他地方只需要引入这个model就可以给cell赋值
struct ComicModel: HandyJSON {
    var comicId: Int = 0
    var comic_id: Int = 0
    var cate_id: Int = 0
    var name: String?
    var title: String?
    var itemTitle: String?
    var subTitle: String?
    var author_name: String?
    var author: String?
    var cover: String?
    var wideCover: String?
    var content: String?
    var description: String?
    var short_description: String?
    var affiche: String?
    var tag: String?
    var tags: [String]?
    var group_ids: String?
    var theme_ids: String?
    var url: String?
    var read_order: Int = 0
    var create_time: TimeInterval = 0
    var last_update_time: TimeInterval = 0
    var deadLine: TimeInterval = 0
    var new_comic: Bool = false
    var chapter_count: Int = 0
    var cornerInfo: Int = 0
    var linkType: Int = 0
    var specialId: Int = 0
    var specialType: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argCon: Int = 0
    var flag: Int = 0
    var conTag: Int = 0
    var isComment: Bool = false
    var is_vip: Bool = false
    var isExpired: Bool = false
    var canToolBarShare: Bool = false
    var ext: [ExtModel]?
}

struct ExtModel: HandyJSON {
    var key: String?
    var val: String?
}


