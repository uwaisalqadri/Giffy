//
//  Blur.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import Foundation
import SwiftUI

public struct Blur: UIViewRepresentable {
  @State var style: UIBlurEffect.Style = .systemMaterial

  public init(style: UIBlurEffect.Style) {
    self.style = style
  }
  
  public func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
