//
//  GiphyWidget.swift
//  GiphyWidget
//
//  Created by Uwais Alqadri on 11/3/21.
//

import WidgetKit
import SwiftUI
import Core
import Giphy
import Common

struct GiphyEntry: TimelineEntry {
  var date = Date()
  let total: Int
}

struct WidgetFavoriteView: View {
  let entry: WidgetProvider.Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      LinearGradient(
        colors: [.Theme.purple, .Theme.red],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
      .mask(
        Image(systemName: "heart.fill")
          .resizable()
      )
      .frame(width: 60, height: 55)
      
      Text("\(entry.total)")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white)
      
      +
      
      Text(" Favorite GIFs")
        .font(.headline)
        .fontWeight(.light)
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black.opacity(0.6))
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetFavoriteView(entry: .init(total: 10))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
      .previewDevice(.none)
  }
}

struct GiphyWidget: Widget {
  private let kind = "GiphyWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(
      kind: kind,
      intent: ConfigurationIntent.self,
      provider: WidgetProvider(useCase: WidgetInjection.shared.resolve())
    ) { entry in
      WidgetFavoriteView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    .configurationDisplayName("Giphy Widget")
    .description("Show Your Favorites Giphy!")
    .supportedFamilies([.systemSmall])
  }
}
