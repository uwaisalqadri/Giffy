//
//  ContextMenu.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 28/4/24.
//

import SwiftUI

public extension View {
  func showGiffyMenu<S>(
    _ url: URL?,
    data: Data?,
    withShape shape: S,
    onShowShare: ((Data) -> Void)? = nil
  ) -> some View where S: Shape {
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
          if let data {
            data.copyGifClipboard()
            onShowShare?(data)
          } else {
            Toaster.error(message: "Can't copy the image").show()
          }
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
