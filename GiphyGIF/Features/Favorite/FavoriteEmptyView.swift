//
//  FavoriteEmptyView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI
import Common

struct FavoriteEmptyView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "favorite_empty", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 220, height: 220)

      Text(FavoriteString.labelFavoriteEmpty.localized)
        .font(.HelveticaNeue.s1SubtitleSemibold)
        .multilineTextAlignment(.center)
    }
  }
}
