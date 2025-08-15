//
//  YouTubWebView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/11/25.
//

import SwiftUI
import WebKit

struct YouTubeWebView: UIViewRepresentable {
    let url: URL   

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 이미 같은 URL이면 재로딩하지 않도록
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}
