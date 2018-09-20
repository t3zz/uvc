//
//  FirstViewController.swift
//  uvc
//
//  Created by Nicole Carmack on 2018-09-17.
//  Copyright © 2018 Nicole Carmack. All rights reserved.
//

import UIKit
import WebKit

class FirstViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
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
        // Set navigationDelegate
        webView.navigationDelegate = self

        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false

        let url = URL (string: "https://undergroundvampireclub.com");
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

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("undergroundvampireclub.com"),
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
}
