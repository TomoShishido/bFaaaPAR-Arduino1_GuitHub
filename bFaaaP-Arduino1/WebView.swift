//
//  WebView.swift
//  bFaaaP-Arduino1
//
//  Created by 宍戸知行 on 2020/05/17.
//  Copyright © 2020 宍戸知行. All rights reserved.
//


import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    var webURLString: String
    @ObservedObject var webViewClass = WebViewClass()

    func makeUIView(context: Context) -> WKWebView  {
        let viewConfiguration = WKWebViewConfiguration()
        self.webViewClass.webView = WKWebView(frame: .zero, configuration: viewConfiguration)
        
        self.webViewClass.webView.uiDelegate = self.webViewClass
        
        
        return self.webViewClass.webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let encoderUrlString: String = self.webURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: encoderUrlString) {
        
            let req = URLRequest(url: url)
            uiView.load(req)
        }
    }
}

//webViewClassをclassのobjectとして提供する
final class WebViewClass: UIViewController, ObservableObject, WKUIDelegate{
    @Published var webView: WKWebView!
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
}




