//
//  TapScale.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

public struct TapScaleEffectModifier: ViewModifier {
  @State private var isPressed = false
  var maximumScaleEffect: CGFloat = 1.7

  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(
        TapGesture()
          .onEnded { _ in
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
              isPressed = false
            }
          }
      )
      .scaleEffect(isPressed ? maximumScaleEffect : 1)
      .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressed)
  }
}

public extension View {
  func tapScaleEffect(maximumScaleEffect: CGFloat = 1.7) -> some View {
    self.modifier(TapScaleEffectModifier(maximumScaleEffect: maximumScaleEffect))
  }
}
