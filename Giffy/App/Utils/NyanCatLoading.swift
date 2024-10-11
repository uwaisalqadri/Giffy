//
//  NyanCatLoading.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 15/10/23.
//

import SwiftUI
import Common

struct NyanCatLoading: View {
  var body: some View {
    LottieView(fileName: "nyan_cat", bundle: Bundle.common, loopMode: .loop)
      .frame(width: 200, height: 200)
      .padding(.trailing, -40)
  }
}
