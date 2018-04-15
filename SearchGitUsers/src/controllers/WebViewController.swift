//
//  WebViewController.swift
//  SearchGitUsers
//
//  Created by 福田光祐 on 2018/04/12.
//  Copyright © 2018年 福田光祐. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var userName: String?
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        self.navigationItem.title = userName
        self.view.addSubview(webView)
        
        urlStr = urlStr?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url:URL? = URL(string: urlStr!)
        let urlRequest:URLRequest? = URLRequest(url: url!)
        guard urlRequest != nil else {return}
        self.webView.load(urlRequest!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
