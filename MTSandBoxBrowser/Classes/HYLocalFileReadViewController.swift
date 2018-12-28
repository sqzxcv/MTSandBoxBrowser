//
//  MTSandBoxBrowserViewController.swift
//  Hey
//
//  Created by hebing on 2018/12/27.
//  Copyright © 2018 Giant Inc. All rights reserved.
//

import UIKit
import GCDWebServer
import WebKit
import AFNetworking
//MARK:- Init
@objc class MTSandBoxBrowserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.addNotification()
    }
    
    deinit {
        //移除通知
        self.webServer.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var webView: WKWebView = {
        let webViewConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), configuration:webViewConfiguration )
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = true
        webView.backgroundColor = UIColor.white
        webView.scrollView.backgroundColor = UIColor.white
        return webView
    }()
    

    /// 左侧返回按钮
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        let img = UIImage(named: "HY_Back")
        backBtn.frame = CGRect(x: 10, y: 0, width: (img?.size.width)!, height: (img?.size.height)!)
        backBtn.setBackgroundImage(img, for: .normal)
        backBtn.setBackgroundImage(img, for: .highlighted)
        backBtn.addTarget(self, action: #selector(MTSandBoxBrowserViewController.onClickLeftBackBtn), for: .touchUpInside)
        return backBtn
    }()
    
    public var savePath: String = NSHomeDirectory()
    fileprivate var url :String? = ""


    
    fileprivate var isNeedShowDisConnectAlert = true
    
    lazy fileprivate var webServer: GCDWebUploader = {
        let webServer = GCDWebUploader(uploadDirectory: self.savePath)
        NSLog("文件存储位置 :" + self.savePath)
        webServer.allowHiddenItems = false
//        webServer.isEnableCreadtFold = false
        webServer.title = "嘿嘿文件浏览"
        webServer.prologue = ""
        webServer.epilogue = ""
        webServer.delegate = self
        return webServer
    }()
    
    
}

//MARK:- UI
extension MTSandBoxBrowserViewController {
    func setUI() {

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn) 
        self.setSubViews()
        self.setSubViewConstraints()
       //开始加载网页
                let manager = AFNetworkReachabilityManager()
        if self.webServer.start() == true && manager.networkReachabilityStatus == .reachableViaWiFi {
//            self.url = manager.g
            self.navigationItem.title = self.url
            let url = URL(string: self.url ?? "")
            if url != nil {
                //设置无缓存策略和超时
//                self.webView.load(URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0))
                do {
                    let htmlData = try Data(contentsOf: url!)
                    if #available(iOS 9.0, *) {
                        self.webView.load(htmlData, mimeType: "ext/html", characterEncodingName: "UTF-8", baseURL: url!)
                    } else {
                    self.webView.load(URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0))
                    }
                    
                } catch {
                    self.navigationItem.title = "请将手机接到Wi-Fi"
                }
               
            }
        }else{
            self.navigationItem.title = "请将手机接到Wi-Fi"
        }
      
    }
    
    func setSubViews() {
        self.webView.frame = self.view.bounds;
        self.view.addSubview(self.webView)
    }
    
    func setSubViewConstraints() {
        
    }
}

//MARK:- Private
extension MTSandBoxBrowserViewController {
    func showDisConnectAlert() {
        if self.isNeedShowDisConnectAlert == false{
            return
        }
        let alert = UIAlertController(title: nil, message: "无法连接到Wi-Fi，请在手机上打开Wi-Fi并刷新此页", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "确定", style: .cancel) { (alert) in
        }
        alert.addAction(confirm)
        self.isNeedShowDisConnectAlert = false
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK:- Action
extension MTSandBoxBrowserViewController {
    @objc fileprivate func onClickLeftBackBtn() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK:- Delegate
extension MTSandBoxBrowserViewController:WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate{
    ////    //是否允许缩放

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){

    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){

       
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){

    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){

        
    }
    
    //Alert弹框
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "好的", style: UIAlertAction.Style.cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //confirm弹框
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (_) in
            completionHandler(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //TextInput弹框
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void){
        let alert = UIAlertController(title: "", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textFiled) in
            textFiled.text = defaultText
        }
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


//MARK:- Notification
extension MTSandBoxBrowserViewController {
    fileprivate func addNotification() {
        let manager = AFNetworkReachabilityManager()
        manager.startMonitoring()
        /**
         typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
         AFNetworkReachabilityStatusUnknown          = -1, // 为止网络
         AFNetworkReachabilityStatusNotReachable     = 0, // 没有联网
         AFNetworkReachabilityStatusReachableViaWWAN = 1, // 手机自带网络
         AFNetworkReachabilityStatusReachableViaWiFi = 2, // WIFI
         };
         */

        manager.setReachabilityStatusChange { (statue
            ) in
            switch statue {
            case .reachableViaWiFi:
               self.isNeedShowDisConnectAlert = true
            default:
                if self.isNeedShowDisConnectAlert == true{
                    self.showDisConnectAlert()
                }
              break
            }
            
        }
    }
}

extension MTSandBoxBrowserViewController:GCDWebUploaderDelegate{

    func webServerDidStop(_ server: GCDWebServer) {
        
    }
    
    func webServerDidStart(_ server: GCDWebServer) {
        
    }
    
    func webServerDidDisconnect(_ server: GCDWebServer) {
        
    }
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        let fileName = (path as NSString).lastPathComponent

    }
    
    func webUploader(_ uploader: GCDWebUploader, didDownloadFileAtPath path: String) {
        
    }
    
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        let fileName = (path as NSString).lastPathComponent

    }
}
