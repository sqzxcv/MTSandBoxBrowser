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
public class MTSandBoxBrowserViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.addNotification()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.startWebServeDeal()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
         self.webServer.stop()
    }
    
    deinit {
        //移除通知
       
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
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let imag = UIImage(named: "back_b")
        if imag != nil{
            btn.setBackgroundImage(imag, for: .normal)
        }else{
            btn.setTitle("back", for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
        }
        btn.addTarget(self, action: #selector(MTSandBoxBrowserViewController.onClickLeftBackBtn), for: .touchUpInside)
        return btn
    }()
    
    public var savePath: String = NSHomeDirectory()
    fileprivate var url :String? = ""


    
    fileprivate var isNeedShowDisConnectAlert = true
    
    lazy fileprivate var webServer: GCDWebUploader = {
        let webServer = GCDWebUploader(uploadDirectory: self.savePath)
        NSLog("文件存储位置 :" + self.savePath)
        webServer.allowHiddenItems = false
//        webServer.isEnableCreadtFold = false
        webServer.title = "Browse Sandbox files"
        webServer.prologue = " "
        webServer.epilogue = " "
        webServer.delegate = self
        return webServer
    }()
    
    
}

//MARK:- UI
extension MTSandBoxBrowserViewController {
    func setUI() {
        let leftItem = UIBarButtonItem(customView: self.backBtn)
        self.navigationItem.leftBarButtonItem = leftItem
        self.setSubViews()
        self.setSubViewConstraints()
 
      
    }

    func startWebServeDeal() {
        //开始加载网页
        let manager = AFNetworkReachabilityManager.shared()
        if self.webServer.start() == true {
            self.url = self.webServer.serverURL?.absoluteString
            self.navigationItem.title = self.url
            let url = URL(string: self.url ?? "")
            if url != nil {
                //设置无缓存策略和超时
                //                self.webView.load(URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0))
                do {
                    let htmlData = try Data(contentsOf: url!)
                    if #available(iOS 9.0, *) {
                        self.webView.load(htmlData, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url!)
                    } else {
                        self.webView.load(URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0))
                    }
                    
                } catch {
                    self.navigationItem.title = "No Wi-Fi"
                }
                
            }
        }else{
            if manager.networkReachabilityStatus != .reachableViaWiFi{
                self.navigationItem.title = "No Wi-Fi"
            }else{
                if webServer.start() == false{
                    NSLog("GCDWebServer not running")
                }
                self.navigationItem.title = "GCDWebServer not running"
            }
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
        let alert = UIAlertController(title: nil, message: "No Wi-Fi", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .cancel) { (alert) in
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
            if self.navigationController != nil && (self.navigationController?.viewControllers.count ?? 0) > 1{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            
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
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //confirm弹框
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (_) in
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
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


//MARK:- Notification
extension MTSandBoxBrowserViewController {
    fileprivate func addNotification() {
        let manager = AFNetworkReachabilityManager.shared()
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

  private func webServerDidStop(_ server: GCDWebServer) {
        NSLog("GCDWebServer not running")
    }
    
    private func webServerDidStart(_ server: GCDWebServer) {
         NSLog("webServerDidStart")
    }
    
    private func webServerDidDisconnect(_ server: GCDWebServer) {
        NSLog("GCDWebServer not running")
    }
    
    private func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
         NSLog("didUploadFileAtPath")
//        let fileName = (path as NSString).lastPathComponent

    }
    
    private func webUploader(_ uploader: GCDWebUploader, didDownloadFileAtPath path: String) {
         NSLog("didDownloadFileAtPath")
    }
    
   private func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
         NSLog("didCreateDirectoryAtPath")
    }
    
    private func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        
    }
    
    private func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
//        let fileName = (path as NSString).lastPathComponent

    }
}
