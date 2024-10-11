//
//  AnimatedGradientBackground.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

struct AnimatedGradientBackground: View {

  @State private var shouldAnimate = false

  var body: some View {
    LinearGradient(
      colors: [.Theme.purple, .Theme.red],
      startPoint: shouldAnimate ? .topLeading : .bottomTrailing,
      endPoint: shouldAnimate ? .bottomTrailing : .topLeading
    )
    .onAppear {
      let animation = Animation.easeOut(duration: 2.0).repeatForever(autoreverses: true)
      withAnimation(animation) {
        shouldAnimate.toggle()
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation(animation) {
          self.shouldAnimate.toggle()
        }
      }
    }
  }
}
