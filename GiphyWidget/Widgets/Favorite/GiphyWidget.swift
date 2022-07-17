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

struct GiphyProvider: IntentTimelineProvider {

  private var giphyEntry: GiphyEntry = {
    let giphy = GiphyEntity()
    giphy._images?._original?.url = "https://media4.giphy.com/media/loLO30j5PEbLgAqt63/giphy.gif"
    return GiphyEntry(giphy: giphy)
  }()

  func placeholder(in context: Context) -> GiphyEntry {
    giphyEntry
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (GiphyEntry) -> Void) {
    completion(giphyEntry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<GiphyEntry>) -> Void) {
    let presenter: WidgetPresenter = WidgetInjection.shared.resolve()
    var entries = [GiphyEntry]()

    presenter.getList(request: "")

    presenter.list
      .forEach { giphy in
        let entry = GiphyEntry(giphy: giphy as? GiphyEntity ?? .init())
        entries.append(entry)
      }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct GiphyEntry: TimelineEntry {
  var date = Date()
  let giphy: GiphyEntity
}

struct GiphyEntryView: View {
  let entry: GiphyProvider.Entry

  var body: some View {
    VStack(alignment: .leading) {
      AnimatedImage(url: URL(string: entry.giphy._images?._original?.url ?? ""), isAnimating: .constant(true))
        .indicator(SDWebImageActivityIndicator.medium)
        .resizable()
        .scaledToFit()
        .cornerRadius(20)
    }
  }
}

@main
struct GiphyWidget: Widget {
  private let kind = "GiphyWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: GiphyProvider()) { entry in
      GiphyEntryView(entry: entry)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    .configurationDisplayName("Giphy Widget")
    .description("Show Your Favorites Giphy!")
    .supportedFamilies([.systemSmall])
  }
}
