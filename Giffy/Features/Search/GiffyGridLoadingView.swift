//
//  SearchEmptyView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI
import CommonUI

struct GiffyGridLoadingView: View {
  var body: some View {
    HStack(alignment: .top) {
      ForEach(SearchReducer.GridSide.allCases, id: \.self) { side in
        LazyVStack(spacing: 8) {
          ForEach((0..<18), id: \.self) { _ in
            row.padding(.horizontal, 5)
          }
        }
      }
    }
  }
  
  var row: some View {
    VStack(alignment: .leading) {
      Color.randomColor
      .frame(
        idealWidth: CGFloat((86...230).randomElement() ?? 86),
        idealHeight: CGFloat((86...230).randomElement() ?? 86),
        alignment: .center
      )
      .scaledToFit()
      .cornerRadius(10)
      .padding(.top, 10)
    }
  }
}
