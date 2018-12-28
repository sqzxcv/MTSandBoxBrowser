//
//  ViewController.swift
//  MTSandBoxBrowser
//
//  Created by sqzxcv on 12/27/2018.
//  Copyright (c) 2018 sqzxcv. All rights reserved.
//

import UIKit
import MTSandBoxBrowser
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.startBtn)
        // Do any additional setup after loading the view, typically from a nib.
    }

    lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 30, y: 200, width: 250, height: 50)
        btn.setTitle("Browse Sandbox files", for: .normal)
        btn.backgroundColor = UIColor.yellow
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(ViewController.onClickStartBtn), for: .touchUpInside)
        return btn
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = MTSandBoxBrowserViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
    }
    
    @objc fileprivate func onClickStartBtn() {
        let vc = MTSandBoxBrowserViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

