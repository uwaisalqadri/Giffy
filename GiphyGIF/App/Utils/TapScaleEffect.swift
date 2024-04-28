//
//  TapScale.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

struct TapScaleEffectModifier: ViewModifier {
  @State private var isClicked = false
  var maximumScaleEffect: CGFloat = 1.7

  func body(content: Content) -> some View {
    content
      .simultaneousGesture(
        TapGesture()
          .onEnded { _ in
            isClicked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              isClicked = false
            }
          }
      )
      .scaleEffect(isClicked ? maximumScaleEffect : 1)
      .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isClicked)
  }
}

extension View {
  func tapScaleEffect(maximumScaleEffect: CGFloat = 1.7) -> some View {
    self.modifier(TapScaleEffectModifier(maximumScaleEffect: maximumScaleEffect))
  }
}
