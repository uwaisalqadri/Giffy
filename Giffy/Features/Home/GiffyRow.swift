//
//  GiffyRow.swift
//  Giffy
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import Common
import CommonUI

struct GiffyRow: View {

  @State private var downloadedImage: Data?
  @State private var isSelected = false
  @State var isFavorite = false
  @State private var isShowShare = false
  let giphy: Giffy

  var onTapRow: ((Giffy) -> Void)?
  var onFavorite: ((Giffy) -> Void)?
  var onShare: ((Data?) -> Void)?

  var body: some View {
    ZStack {
      GIFView(
        url: URL(string: giphy.image.url),
        downloadedImage: $downloadedImage
      )
      .frame(maxHeight: 350, alignment: .center)
      .cornerRadius(30)
      .overlay(
        HStack {
          VStack(alignment: .leading) {
            if let trendingDate = giphy.trendingDateTime.stringToDate()?.string(), !trendingDate.contains("1970") {
              Text(key: .labelTrendingDate)
                .foregroundColor(.white)
                .font(.semibold, size: 14)

              Text(trendingDate)
                .foregroundColor(.white)
                .font(.medium, size: 12)
            }
          }

          Spacer()

          if let onFavorite {
            FavoriteButton(isFavorite: $isFavorite, size: .init(width: 40, height: 40)) {
              onFavorite(giphy)
            }
            .padding(.trailing, 10)
          }

        }.frame(height: 40).padding([.horizontal, .top], 15),
        alignment: .top
      )

      footer
        .padding(.top, 250)
    }
    .scaleEffect(isSelected ? 1.2 : 1)
    .animation(.linear(duration: 0.2), value: isSelected)
  }

  @ViewBuilder
  var footer: some View {
    HStack {
      if !giphy.title.isEmpty {
        VStack(alignment: .leading) {
          Text(giphy.title)
            .foregroundColor(.white)
            .font(.bold, size: 16)
            .lineLimit(1)
          
          Text(giphy.username.ifEmpty { "Unnamed" })
            .foregroundColor(.white)
            .font(.medium, size: 14)
        }
      }
      
      Spacer()

      RedirectButton(onClick: {
        onTapRow?(giphy)
      })
      .showGiffyMenu(
        URL(string: giphy.url),
        data: downloadedImage,
        withShape: .circle,
        onShowShare: onShare
      )
    }
    .padding(.leading, 20)
    .padding(.trailing, 15)
    .padding(.vertical, 15)
    .frame(maxHeight: 160)
    .background(
      Group {
        if giphy.title.isEmpty {
          EmptyView()
        } else {
          Blur(style: .systemUltraThinMaterialDark)
            .clipShape(.capsule)
            .padding(5)
        }
      }
    )
  }
}
