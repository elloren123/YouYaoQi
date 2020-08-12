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

/*
 请求到的所有的数据源,都是如下结构
 {
 code:
 data:{
        message:
        stateCode:
        returnData:[
                    "XXX1":[{},{},{},...],
                    "XXX2":[{},{},{},...],
                    "XXX3":[{},{},{},...],
                    ...
                    ]
      }
 
 }
 
 */
struct ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: ReturnData<T>?
}



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

//MARK: 首页推荐的三个模型数据
//cell
struct ComicListModel: HandyJSON {
    var comicType: UComicType = .none
    var canedit: Bool = false
    var sortId: Int = 0
    var titleIconUrl: String?
    var newTitleIconUrl: String?
    var description: String?
    var itemTitle: String?
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    var argType: Int = 0
    var comics:[ComicModel]?
    var maxSize: Int = 0
    var canMore: Bool = false
    var hasMore: Bool = false
    var spinnerList: [SpinnerModel]?
    var defaultParameters: DefaultParametersModel?
    var page: Int = 0
}
//轮播
struct GalleryItemModel: HandyJSON {
    var id: Int = 0
    var linkType: Int = 0
    var cover: String?
    var ext: [ExtModel]?
    var title: String?
    var content: String?
}
//cell的一个textModel,现在已经没有手机返回,不清楚啥样
struct TextItemModel: HandyJSON {
    var id: Int = 0
    var linkType: Int = 0
    var cover: String?
    var ext: [ExtModel]?
    var title: String?
    var content: String?
}
//cell中的heder的跳转区分方式
enum UComicType: Int, HandyJSONEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}
//? 还不清楚
struct SpinnerModel: HandyJSON {
    var argCon: Int = 0
    var name: String?
    var conTag: String?
}
//? 还不清楚
struct DefaultParametersModel: HandyJSON {
    var defaultSelection: Int = 0
    var defaultArgCon: Int = 0
    var defaultConTagType: String?
}
//这个是为了传入请求数据中获取model的最外层数据结构
struct BoutiqueListModel: HandyJSON {
    var galleryItems: [GalleryItemModel]?
    var textItems: [TextItemModel]?
    var comicLists: [ComicListModel]?
    var editTime: TimeInterval = 0
}

