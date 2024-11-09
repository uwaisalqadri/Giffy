//
//  SearchEmptyView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI
import CommonUI

struct SearchEmptyView: View {
  var body: some View {
    VStack {
      LottieView(fileName: "search_empty", bundle: Bundle.common, loopMode: .loop)
        .frame(width: 200, height: 200)
        .padding(.bottom, 5)

      Text(SearchString.labelSearching.localized)
        .font(.HelveticaNeue.s1SubtitleSemibold)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
  }
}
