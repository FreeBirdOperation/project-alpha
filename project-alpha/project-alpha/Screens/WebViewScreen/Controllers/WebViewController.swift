//
//  WebViewController.swift
//  project-alpha
//
//  Created by Daniel Seitz on 5/28/18.
//  Copyright © 2018 freebird. All rights reserved.
//

import Foundation
import WebKit

class WebViewController: PAViewController {
  private var webView: WKWebView
  
  init(configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
    webView = WKWebView(frame: CGRect.zero, configuration: configuration)
    super.init()
    
    view.addSubview(webView)
    webView.autoPinEdgesToSuperviewEdges()
    webView.navigationDelegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    
    navigationItem.leftBarButtonItem = cancelButton
  }
  
  @objc
  private func cancelTapped() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
//  - (void)viewDidLoad
//  {
//  [super viewDidLoad];
//
//  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButton:)];
//  self.navigationItem.rightBarButtonItem = doneButton;
//  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func navigate(to url: URL) {
    webView.load(URLRequest(url: url))
  }
}

extension WebViewController: WKNavigationDelegate {
  
}
