//
//  GiffyRow.swift
//  Giffy
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Common
import CommonUI

struct GiffyRow: View {

  @State private var downloadedImage: Data?
  @State private var isSelected = false
  @State var isFavorite = false
  let giphy: Giffy

  var onTapRow: ((Giffy) -> Void)?
  var onFavorite: ((Giffy) -> Void)?

  var body: some View {
    ZStack {
      AnimatedImage(
        url: URL(string: giphy.image.url),
        options: [.scaleDownLargeImages, .queryMemoryData, .highPriority],
        isAnimating: .constant(true),
        placeholder: { Color.randomColor }
      )
      .onSuccess { _, data, _ in
          downloadedImage = data
      }
      .resizable()
      .scaledToFill()
      .frame(maxHeight: 350, alignment: .center)
      .cornerRadius(30)
      .overlay(
        HStack {
          VStack(alignment: .leading) {
            if let trendingDateTime = giphy.trendingDateTime.stringToDate()?.string() {
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

        }.frame(height: 40).padding([.horizontal, .top], 15),
        alignment: .top
      )

      footer
        .padding(.top, 250)
        .onTapGesture {
          onTapRow?(giphy)
        }
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
      .showGiphyMenu(
        URL(string: giphy.url),
        data: downloadedImage,
        withShape: .circle
      )
    }
    .padding(.leading, 20)
    .padding(.trailing, 15)
    .padding(.vertical, 15)
    .frame(maxHeight: 160)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .clipShape(Capsule())
        .padding(5)
    )
  }
}
