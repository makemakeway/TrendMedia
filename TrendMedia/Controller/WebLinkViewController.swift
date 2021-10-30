//
//  WebLinkViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/18.
//

import UIKit
import WebKit

class WebLinkViewController: UIViewController {

    //MARK: Property
    
    @IBOutlet weak var webViewTitle: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    var webViewTitleString: String = ""
    var linkKey = "" {
        didSet {
            loadUrl()
        }
    }
    
    //MARK: Method
    
    func loadUrl() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(linkKey)") else {
            return
        }
        let req = URLRequest(url: url)
        webView.load(req)
        
    }
    
    func titleConfig() {
        webViewTitle.text = webViewTitleString
        webViewTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    
    @IBAction func reloadPage(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleConfig()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

}

extension WebLinkViewController: WKUIDelegate, WKNavigationDelegate {

}
