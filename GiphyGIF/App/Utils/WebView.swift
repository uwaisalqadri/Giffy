//
//  WebView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 29/05/21.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {

  let url: URL?

  func makeUIView(context: Context) -> WKWebView {
    let prefs = WKWebpagePreferences()
    prefs.allowsContentJavaScript = true
    let config = WKWebViewConfiguration()
    config.defaultWebpagePreferences = prefs
    return WKWebView(frame: .zero, configuration: config)
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    guard let url = url else { return }
    let request = URLRequest(url: url)
    uiView.load(request)
  }

}
