//
//  InfoViewController.swift
//  Test3DViewer
//
//  Created by セラフ on 2015/03/06.
//  Copyright (c) 2015年 セラフ. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "INFO"
        
        let _view = UIWebView(frame: view.frame)
        let _path = NSBundle.mainBundle().pathForResource("info", ofType: "html")!
        let _url = NSURL(fileURLWithPath: _path)!
        
        _view.loadRequest(NSURLRequest(URL: _url))
        view.addSubview(_view)
    }
}