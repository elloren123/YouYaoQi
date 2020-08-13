//
//  UWebViewController.swift
//  U17_ZSY
//
//  Created by LEPU on 2020/8/12.
//  Copyright © 2020 LEPU. All rights reserved.
/*
 
 一个加载URL的webView
 
 */


import UIKit

import WebKit

class UWebViewController: UBaseViewController {
    
    var request: URLRequest!
    //MARK: - 懒加载
    //webView
    lazy var webView: WKWebView = {
        let ww = WKWebView()
        //指示水平滑动手势是否会触发前向列表导航;即 水平滑动可以通过导航堆栈返回上一级
        ww.allowsBackForwardNavigationGestures = true
        ww.navigationDelegate = self
        ww.uiDelegate = self;
        return ww
    }()
    
    //进度条视图
    lazy var progressView: UIProgressView = {
        let pw = UIProgressView()
        pw.trackImage = UIImage.init(named: "nav_bg")
        pw.progressTintColor = UIColor.white
        return pw
    }()
    
    //MARK: - 系统构造函数
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加网页加载进度的监听
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.load(request)
    }
    
    
    override func configUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints{
            $0.edges.equalTo(self.view.snp.edges)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        //添加一个刷新
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                            target: self,
                                                            action: #selector(reload))
        //设置导航栏标题的颜色和大小
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    //重写返回事件
    override func pressBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //析构函数
    deinit {
        //移除监听
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

//代理方法,获取进度
//这里没有使用到 WKUIDelegate
extension UWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            //判断加载是否完成,是否隐藏
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //复位
        progressView.setProgress(0.0, animated: false)
        //设置标题
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}

