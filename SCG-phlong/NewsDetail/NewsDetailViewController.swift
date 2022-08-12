//
//  NewsDetailViewController.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import UIKit
import WebKit
class NewsDetailViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private var viewModel: NewsDetailViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupViews() {
        activity.hidesWhenStopped = true
        webView.navigationDelegate = self
        if let stringUrlArticle = viewModel.article.url, let urlArticle = URL(string: stringUrlArticle) {
            let urlRequest = URLRequest(url: urlArticle)
            activity.startAnimating()
            webView.load(urlRequest)
        }
    }
}

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
    }
}
