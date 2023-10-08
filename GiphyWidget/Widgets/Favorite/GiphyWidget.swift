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
import SDWebImageSwiftUI

struct GiphyEntry: TimelineEntry {
  var date = Date()
  let giphy: Giphy
}

struct WidgetFavoriteView: View {
  let entry: WidgetProvider.Entry

  var body: some View {
    VStack(alignment: .leading) {
//      AnimatedImage(url: URL(string: entry.giphy.url), isAnimating: .constant(true))
//        .indicator(SDWebImageActivityIndicator.medium)
      Image("img-gumball")
        .resizable()
        .scaledToFill()
        .cornerRadius(20)
    }
  }
}

@main
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
