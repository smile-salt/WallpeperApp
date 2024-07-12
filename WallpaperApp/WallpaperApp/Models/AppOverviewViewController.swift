//
//  AppOverviewViewController.swift
//  WallpaperApp
//
//  Created by tdc on 2024/06/02.
//

import UIKit
import WebKit

class AppOverviewViewController: UIViewController {

    var profileURL: URL?
       
       let webView: WKWebView = {
           let webView = WKWebView()
           webView.translatesAutoresizingMaskIntoConstraints = false
           return webView
       }()

       override func viewDidLoad() {
           super.viewDidLoad()
           
           view.addSubview(webView)
           setupConstraints()
           
           guard let url = profileURL else { return }
           let request = URLRequest(url: url)
           webView.load(request)
       }
       
       func setupConstraints() {
           webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
           webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
           webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
           webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       }

}
