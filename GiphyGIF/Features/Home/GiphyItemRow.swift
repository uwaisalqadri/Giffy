//
//  GiphyItemRow.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Giphy
import Common

struct GiphyItemRow: View {

  @State private var isAnimating = true
  @State private var isSelected = false
  @State var isFavorite = false
  let giphy: Giphy

  var onTapRow: ((Giphy) -> Void)?
  var onFavorite: ((Giphy) -> Void)?

  var body: some View {
    ZStack {
      AnimatedImage(url: URL(string: giphy.image.url), isAnimating: $isAnimating) {
        Color.randomColor
      }
      .resizable()
      .scaledToFill()
      .background(Color.randomColor)
      .frame(maxHeight: 350, alignment: .center)
      .cornerRadius(30)
      .overlay(
        HStack {
          VStack(alignment: .leading) {
            if let trendingDateTime = giphy.trendingDateTime.stringToDate()?.string(format: "d MMM yyyy") {
              Text("Trending Date")
                .foregroundColor(.white)
                .font(.HelveticaNeue.captionRegular)

              Text(trendingDateTime)
                .foregroundColor(.white)
                .font(.HelveticaNeue.s1SubtitleBold)
            }
          }

          Spacer()

          if let onFavorite {
            FavoriteButton(isFavorite: $isFavorite, size: .init(width: 40, height: 40)) {
              onFavorite(giphy)
            }
            .tapScaleEffect()
            .padding(.trailing, 10)
          }

        }.frame(height: 40).padding([.horizontal, .top], 15)
        , alignment: .top
      )

      footer
        .padding(.top, 250)
    }
    .scaleEffect(isSelected ? 1.2 : 1)
    .animation(.linear(duration: 0.2), value: isSelected)
  }

  var footer: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(giphy.title)
          .foregroundColor(.white)
          .font(.HelveticaNeue.s1SubtitleBold)
          .lineLimit(1)

        Text(giphy.username.isEmpty ? "Unnamed" : giphy.username)
          .foregroundColor(.white)
          .font(.HelveticaNeue.s1SubtitleRegular)
      }

      Spacer()

      RedirectButton(onClick: {
        onTapRow?(giphy)
      })
      .tapScaleEffect()
      .padding(.horizontal, 10)
    }
    .padding(.all, 20)
    .frame(maxHeight: 160)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .clipShape(Capsule())
        .padding(5)
    )
  }
}
