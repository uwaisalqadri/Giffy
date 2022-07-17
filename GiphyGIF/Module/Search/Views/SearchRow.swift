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

  @State var isAnimating = true
  @State var showDetail = false
  @State var isFavorite = false
  let giphy: Giphy
  let router: DetailRouter

  var removeFavoriteHandler: ((Giphy) -> Void)?

  var body: some View {
    ZStack {
      AnimatedImage(url: URL(string: giphy.images.original.url), isAnimating: $isAnimating)
        .placeholder(content: {
          Color(Common.loadRandomColor())
        })
        .resizable()
        .scaledToFill()
        .frame(maxHeight: 350, alignment: .center)
        .cornerRadius(20)
        .sheet(isPresented: $showDetail) {
          router.routeDetail(giphy: giphy)
        }
        .onTapGesture {
          if !isFavorite {
            showDetail.toggle()
          }
        }
        .overlay(
          ZStack {
            if isFavorite {
              Button(action: {
                removeFavoriteHandler?(giphy)
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
