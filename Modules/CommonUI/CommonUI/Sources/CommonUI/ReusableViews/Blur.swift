//
//  Blur.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import Foundation
import SwiftUI

public struct Blur: View {
  @State var style: UIBlurEffect.Style = .systemMaterial
  var interactive: Bool = false

  public init(style: UIBlurEffect.Style = .systemMaterial, interactive: Bool = true) {
    self.style = style
    self.interactive = interactive
  }
  
  public var body: some View {
    if #available(iOS 26.0, *) {
      // Use SwiftUI glass effect for iOS 26+
      Rectangle()
        .fill(.clear)
        .glassEffect(interactive ? .clear.interactive() : .clear, in: .rect)
    } else {
      // Fallback to UIViewRepresentable for older iOS
      LegacyBlur(style: style)
    }
  }
}

// Backward compatible UIViewRepresentable implementation
public struct LegacyBlur: UIViewRepresentable {
  @State var style: UIBlurEffect.Style = .systemMaterial

  public init(style: UIBlurEffect.Style = .systemMaterial) {
    self.style = style
  }
  
  public func makeUIView(context: Context) -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blurEffect)
    
    // Enhanced styling for liquid glass appearance on older iOS
    blurView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    
    // Subtle border for glass definition
    blurView.layer.borderWidth = 0.5
    blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
    
    return blurView
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
