//
//  GiffyWidget.swift
//  GiffyWidget
//
//  Created by Uwais Alqadri on 11/3/21.
//

import WidgetKit
import SwiftUI
import Core
import Common
import CommonUI

struct WidgetFavoriteView: View {
  let entry: WidgetProvider.Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      LinearGradient(
        colors: [.Theme.green, .Theme.blueSky],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
      .mask(
        Image(systemName: "doc.on.clipboard.fill")
          .resizable()
      )
      .frame(width: 40, height: 50)

      Text("\(entry.total)")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white) +

      Text(" Today's Copied GIFs")
        .font(.headline)
        .fontWeight(.light)
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .widgetBackground(Color.black)
  }
}

extension View {
  func widgetBackground(_ backgroundView: some View) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      return containerBackground(for: .widget) {
        backgroundView
      }
    } else {
      return background(backgroundView)
    }
  }
}

#Preview {
  WidgetFavoriteView(entry: .init(total: 10))
    .previewContext(WidgetPreviewContext(family: .systemSmall))
    .previewDevice(.none)
}

struct GiffyWidget: Widget {
  let provider = WidgetProvider()
  
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: String(describing: Self.self),
      provider: provider
    ) { entry in
      WidgetFavoriteView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.padding(-10))
    }
    .configurationDisplayName("Giphy Widget")
    .description("Show Your Favorites Giphy!")
    .supportedFamilies([.systemSmall])
  }
}
