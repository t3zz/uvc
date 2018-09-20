//
//  SecondViewController.swift
//  uvc
//
//  Created by Nicole Carmack on 2018-09-17.
//  Copyright © 2018 Nicole Carmack. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigationDelegate
        webView.navigationDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
        
        let url = URL (string: "https://soundcloud.com/underground-vampire-club");
        let request = URLRequest(url: url!);
        webView.load(request);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated  {
        if let url = navigationAction.request.url,
            let host = url.host, !host.hasPrefix("soundcloud.com"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            print(url)
            print("Redirected to browser. No need to open it locally")
            decisionHandler(.cancel)
        } else {
            print("Open it locally")
            decisionHandler(.allow)
        }
    } else {
        print("not a user click")
        decisionHandler(.allow)
    }
}
