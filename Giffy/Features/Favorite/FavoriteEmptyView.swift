//
//  FavoriteEmptyView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI
import CommonUI

struct FavoriteEmptyView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "anim_favorite_empty", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 220, height: 220)

      Text(key: .labelFavoriteEmpty)
        .font(.bold, size: 20)
        .multilineTextAlignment(.center)
    }
  }
}
