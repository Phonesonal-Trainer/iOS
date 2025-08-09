//
//  WebView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/8/25.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let onCodeReceived: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeReceived: onCodeReceived)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let onCodeReceived: (String) -> Void

        init(onCodeReceived: @escaping (String) -> Void) {
            self.onCodeReceived = onCodeReceived
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if let url = navigationAction.request.url,
               url.absoluteString.contains("/auth/callback"),
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                
                print("✅ 인증 코드 파싱 성공: \(code)")
                onCodeReceived(code)
                decisionHandler(.cancel) // 더 이상 진행하지 않음
                return
            }

            decisionHandler(.allow)
        }

    }
}
