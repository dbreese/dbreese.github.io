//
//  ExampleViewController.swift
//  SWTest
//
//  Created by Paul Tiarks on 2/27/22.
//

import Foundation
import UIKit
import WebKit

enum DisplayMode {
    case remote
    case local
}

class LocalImageSchemeHandler: NSObject, WKURLSchemeHandler {
    static let scheme = "nativeimage"

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        NSLog("Start: \(urlSchemeTask)")
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        NSLog("Stop: \(urlSchemeTask)")
    }


}

class ExampleViewController: UIViewController {
    let displayMode: DisplayMode
    let schemeHandler = LocalImageSchemeHandler()
    let webView: WKWebView

    init(displayMode: DisplayMode) {
        self.displayMode = displayMode
        let config = WKWebViewConfiguration()
        config.limitsNavigationsToAppBoundDomains = false
        config.setURLSchemeHandler(schemeHandler, forURLScheme: LocalImageSchemeHandler.scheme)
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 500), configuration: config)
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.addSubview(webView)
        switch self.displayMode {
        case .remote:
            loadRemote()

        case .local:
            NSLog("created with local")
        }
    }

    @objc func reload() {
        self.webView.reload()
    }

    func loadRemote() {
        let urlString = "https://dbreese.github.io/"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
