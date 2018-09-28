//
//  FirstViewController.swift
//  uvc
//
//  Created by Nicole Carmack on 2018-09-17.
//  Copyright © 2018 Nicole Carmack. All rights reserved.
//

import UIKit
import WebKit

class FirstViewController: UIViewController, UITabBarControllerDelegate, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    // Add loading indicator
    private var loadingObservation: NSKeyValueObservation?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call tabBarController
        tabBarController?.delegate = self

        // Set navigationDelegate
        webView.navigationDelegate = self

        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = true
        
        // Scrolling Offset Bug Fix
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.bounds = webView.bounds
        }
        
        let url = URL (string: "https://undergroundvampireclub.com/");
        let request = URLRequest(url: url!);
        webView.load(request);
        
        // Setup loading indicator
        loadingObservation = webView.observe(\.isLoading, options: [.new, .old]) { [weak self] (_, change) in
            guard let strongSelf = self else { return }
            
            // this is fine
            let new = change.newValue!
            let old = change.oldValue!
            
            if new && !old {
                strongSelf.view.addSubview(strongSelf.loadingIndicator)
                strongSelf.loadingIndicator.startAnimating()
                NSLayoutConstraint.activate([strongSelf.loadingIndicator.centerXAnchor.constraint(equalTo: strongSelf.view.centerXAnchor),
                                             strongSelf.loadingIndicator.centerYAnchor.constraint(equalTo: strongSelf.view.centerYAnchor)])
                strongSelf.view.bringSubviewToFront(strongSelf.loadingIndicator)
            }
            else if !new && old {
                strongSelf.loadingIndicator.stopAnimating()
                strongSelf.loadingIndicator.removeFromSuperview()
            }
        }
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //
        if webView.url == URL (string: "https://undergroundvampireclub.com/") {
            // do nothing...
            print("doing nothing")
        } else {
            print("reload uvc site")
            let url = URL (string: "https://undergroundvampireclub.com/");
            let request = URLRequest(url: url!);
            webView.load(request);
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Do some stuff before navigation procedures
        let css = "body { background-color : #222 }"
        let cssjs = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        let scrolljs = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        let logojs = "var style = document.createElement('logo')" + "style.text = 'div#td-header-wrap {display:hidden;}';" + "document.head.appendChild(style);"

        webView.evaluateJavaScript(scrolljs, completionHandler: nil)
        webView.evaluateJavaScript(cssjs, completionHandler: nil)
        webView.evaluateJavaScript(logojs, completionHandler: nil)
        
        // Navigation procedures
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("undergroundvampireclub.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Opened external link, Redirected to browser:", url)
                decisionHandler(.cancel)
            } else {
//                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
//            print("not a user click")
            decisionHandler(.allow)
        }
    }
}
