//
//  ContextMenu.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

public extension View {
  func showGiphyMenu<S>(_ url: URL?, data: Data?, withShape shape: S) -> some View where S: Shape {
    self
      .contextMenuShape(shape)
      .contextMenu {
        Button {
          if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
          }
        } label: {
          Label("Open in Browser", systemImage: "safari")
        }
        
        Button {
          guard let data = data else { return }
          data.copyGifClipboard()
          Toaster.success(message: Localizable.labelCopied.tr()).show()
        } label: {
          Label("Copy to Clipboard", systemImage: "doc.on.clipboard.fill")
        }
      }
  }
  
  func contextMenuShape<S>(_ shape: S) -> some View where S: Shape {
    if #available(iOS 15.0, *) {
      return self.contentShape(.contextMenuPreview, shape)
    } else {
      return self.contentShape(shape)
    }
  }
}
