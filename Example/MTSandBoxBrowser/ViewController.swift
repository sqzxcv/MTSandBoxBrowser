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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = MTSandBoxBrowserViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

