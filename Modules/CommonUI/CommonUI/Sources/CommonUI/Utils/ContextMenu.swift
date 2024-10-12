//
//  ContextMenu.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

public extension View {
  func showGiphyMenu(_ url: URL?) -> some View {
    self.contextMenu {
      Button {
        if let url = url, UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        }
      } label: {
        Label("Open in Browser", systemImage: "safari")
      }

      Button {
        Task {
          if let imageURL = url {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            data.copyGifClipboard()
            await Toaster.success(message: "Copied").show()
          }
        }
      } label: {
        Label("Copy to Clipboard", systemImage: "doc.on.clipboard.fill")
      }
    }
  }
}