//
//  Button.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 15/10/23.
//

import SwiftUI

struct IconButton: View {
  
  var iconName: String
  var tint: Color
  var size: CGFloat = 20
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Image(systemName: iconName)
        .font(.system(size: size))
        .foregroundColor(tint)
        .contentShape(.rect)
        .padding(6)
    }
    .buttonStyle(.plain)
  }
}

struct RedirectButton: View {
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Image(systemName: "arrow.up.right")
        .resizable()
        .foregroundColor(.Theme.yellow)
        .frame(width: 17, height: 17)
        .padding(.all, 17)
        .background(Circle().fill(Color.Theme.background))
    }
  }
}

struct FavoriteButton: View {
  @Binding var isFavorite: Bool
  var isInverted: Bool = false
  let size: CGSize
  var margin: CGFloat = 20
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .resizable()
        .foregroundColor(!isInverted ? Color.Theme.red : Color.white)
        .frame(width: size.width - margin, height: size.height - margin - 4)
        .background(
          (!isInverted ? Color.Theme.background : Color.Theme.red)
            .clipShape(.circle)
            .frame(width: size.width, height: size.height)
        )
    }
  }
  
  func frame(width: CGFloat, height: CGFloat) -> Self {
    FavoriteButton(isFavorite: $isFavorite, isInverted: isInverted, size: .init(width: width, height: height), onClick: onClick)
  }
}
