//
//  ImageContainerView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 10/11/24.
//

import SwiftUI
import Common

struct ImageContainerView: View {
  var sticker: Sticker
  var showOriginalImage: Bool = false
  
  var image: Image? {
    showOriginalImage ? sticker.inputImage : sticker.outputImage
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      if (image == nil && !sticker.isGeneratingImage && sticker.errorText == nil) {
        Image(systemName: "photo.badge.plus")
          .font(.system(size: 30))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if let image {
        image
          .resizable()
          .scaledToFit()
          .clipped()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if sticker.isGeneratingImage {
        ProgressView()
          .tint(.Theme.yellow)
          .font(.system(size: 80))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(16)
      }
      
      if let errorText = sticker.errorText {
        Text(errorText)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .font(.caption)
          .foregroundStyle(.red)
          .lineLimit(3)
      }
      
    }
    .overlay(ColorfulDashedOverlay())
  }
}

struct ColorfulDashedOverlay: View {
  var colors: [Color] = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.red]
  
  var body: some View {
    RoundedRectangle(cornerRadius: 25)
      .strokeBorder(
        AngularGradient(
          gradient: Gradient(colors: colors),
          center: .center
        ),
        style: StrokeStyle(lineWidth: 3, dash: [8])
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
  }
}

#Preview {
  VStack {
    ImageContainerView(sticker: .init())
  }
}
