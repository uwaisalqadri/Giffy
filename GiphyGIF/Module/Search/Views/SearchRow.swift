//
//  SearchRow.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Giphy
import Common

struct SearchRow: View {

  @State private var isAnimating = true
  @State var isFavorite = false
  let giphy: Giphy

  var onTapRow: ((Giphy) -> Void)?
  var onRemoveFavorite: ((Giphy) -> Void)?

  var body: some View {
    ZStack {
      AnimatedImage(url: URL(string: giphy.image.url), isAnimating: $isAnimating)
        .placeholder(content: {
          Color.randomColor
        })
        .resizable()
        .scaledToFill()
        .background(Color.randomColor)
        .frame(maxHeight: 350, alignment: .center)
        .cornerRadius(20)
        .onTapGesture {
          if !isFavorite {
            onTapRow?(giphy)
          }
        }
        .overlay(
          ZStack {
            if isFavorite {
              Button(action: {
                onRemoveFavorite?(giphy)
              }, label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                  .resizable()
                  .foregroundColor(.red)
                  .frame(width: 27, height: 25)
              }).padding([.top, .trailing], 20)
            } else {
              EmptyView()
            }
          }, alignment: .topTrailing)

      footer
        .padding(.top, 250)
    }
  }

  var footer: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(giphy.title)
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
          .padding(.leading, 15)

        Text(giphy.username == "" ? "Unnamed" : giphy.username)
          .foregroundColor(.white)
          .font(.system(size: 15, weight: .regular))
          .padding(.leading, 15)
      }

      Spacer()

    }.frame(maxHeight: 130)
    .background(
      Blur(style: .systemUltraThinMaterialDark)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    )
  }
}
