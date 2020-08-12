//
//  UAPI.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/12.
//  Copyright © 2020 LEPU. All rights reserved.
/*

第三方Moya的使用,进行网络请求的配置

*/

import HandyJSON
import Moya
import MBProgressHUD

//请求的加载动画, Moya通知请求的网络活动的变化类NetworkActivityPlugin
let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = topVC else { return } //首页的视图控制器对象没有实例化前,不需要添加
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

//超时时间 requestClosure  (Endpoint, RequestResultClosure )
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<UApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

//发送请求方式一:超时,一种有加载动画,一种没有
let ApiProvider = MoyaProvider<UApi>(requestClosure: timeoutClosure)
//发送请求方式二:加载动画,超时
let ApiLoadingProvider = MoyaProvider<UApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

//配置最基本的接口
enum UApi {
    case searchHot//搜索热门
    case searchRelative(inputText: String)//相关搜索
    case searchResult(argCon: Int, q: String)//搜索结果
    
    case boutiqueList(sexType: Int)//推荐列表
    case special(argCon: Int, page: Int)//专题
    case vipList//VIP列表
    case subscribeList//订阅列表
    case rankList//排行列表

    case cateList//分类列表
    
    case comicList(argCon: Int, argName: String, argValue: Int, page: Int)//漫画列表
    
    case guessLike//猜你喜欢
    
    case detailStatic(comicid: Int)//详情(基本)
    case detailRealtime(comicid: Int)//详情(实时)
    case commentList(object_id: Int, thread_id: Int, page: Int)//评论
    
    case chapter(chapter_id: Int)//章节内容
}

//MARK: - 遵从TargetType协议 ,进行一些基本配置.
extension UApi: TargetType {
    //基础URL
    var baseURL: URL { return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")! }
    //URL的后半部分
    var path: String {
        switch self {
        case .searchHot: return "search/hotkeywordsnew"
        case .searchRelative: return "search/relative"
        case .searchResult: return "search/searchResult"
            
        case .boutiqueList: return "comic/boutiqueListNew"
        case .special: return "comic/special"
        case .vipList: return "list/vipList"
        case .subscribeList: return "list/newSubscribeList"
        case .rankList: return "rank/list"
            
        case .cateList: return "sort/mobileCateList"
            
        case .comicList: return "list/commonComicList"
            
        case .guessLike: return "comic/guessLike"
            
        case .detailStatic: return "comic/detail_static_new"
        case .detailRealtime: return "comic/detail_realtime"
        case .commentList: return "comment/list"
            
        case .chapter: return "comic/chapterNew"
        }
    }
    //请求方式,一般是对每一个的请求进行配置,这里所有的都是get
    var method: Moya.Method { return .get }
    
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .searchRelative(let inputText):
            parmeters["inputText"] = inputText
            
        case .searchResult(let argCon, let q):
            parmeters["argCon"] = argCon
            parmeters["q"] = q
            
        case .boutiqueList(let sexType):
            parmeters["sexType"] = sexType
            
        case .special(let argCon,let page):
            parmeters["argCon"] = argCon
            parmeters["page"] = max(1, page)
            
        case .comicList(let argCon, let argName, let argValue, let page):
            parmeters["argCon"] = argCon
            if argName.count > 0 { parmeters["argName"] = argName }
            parmeters["argValue"] = argValue
            parmeters["page"] = max(1, page)
            
        case .detailStatic(let comicid),
             .detailRealtime(let comicid):
            parmeters["comicid"] = comicid
            
        case .commentList(let object_id, let thread_id, let page):
            parmeters["object_id"] = object_id
            parmeters["thread_id"] = thread_id
            parmeters["page"] = page
            
        case .chapter(let chapter_id):
            parmeters["chapter_id"] = chapter_id
            
        default: break
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用,必须实现
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    //请求头 例//return ["Content-type" : "application/json"]
    var headers: [String : String]? { return nil }
}

//MARK: - 对Moya的 MoyaProvider 进行扩展
//创建一个简易的对外网络请求的接口
extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        //调用Moya的原始的请求
        return request(target, completion: { (result) in
            
            guard let completion = completion else { return }
            
            //得到数据后,通过HandyJSON进行处理
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            
            completion(returnData.data?.returnData)
            
        })
    }
}

//MARK: - 对Moya的 Response 进行扩展
extension Response {
    //主要就是将数据传入model中返回
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        
        let jsonString = String(data: data, encoding: .utf8)
        
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}


