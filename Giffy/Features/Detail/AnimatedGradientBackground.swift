//
//  AnimatedGradientBackground.swift
//  Giffy
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

struct AnimatedGradientBackground: View {

  @State private var shouldAnimate = false
  var colors: [Color] = [.Theme.purple, .Theme.red]

  var body: some View {
    LinearGradient(
      colors: colors,
      startPoint: shouldAnimate ? .topLeading : .bottomTrailing,
      endPoint: shouldAnimate ? .bottomTrailing : .topLeading
    )
    .onAppear {
      let animation = Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true)
      withAnimation(animation) {
        shouldAnimate.toggle()
      }
    }
  }
}
