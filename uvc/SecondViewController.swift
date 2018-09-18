//
//  SecondViewController.swift
//  uvc
//
//  Created by Nicole Carmack on 2018-09-17.
//  Copyright © 2018 Nicole Carmack. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


