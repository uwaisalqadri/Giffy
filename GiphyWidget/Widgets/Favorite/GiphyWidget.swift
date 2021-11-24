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

struct GiphyEntry: TimelineEntry {
  var date = Date()
  let giphy: [Giphy]

}

struct GiphyProvider: TimelineProvider {

  @ObservedObject var presenter: WidgetPresenter

  func placeholder(in context: Context) -> GiphyEntry {
    GiphyEntry(giphy: [])
  }

  func getSnapshot(in context: Context, completion: @escaping (GiphyEntry) -> Void) {
    var giphys = [Giphy]()

    if !presenter.isLoading {
      giphys = presenter.list
    }

    let entry = GiphyEntry(giphy: giphys)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<GiphyEntry>) -> Void) {
    var giphys = [Giphy]()

    if !presenter.isLoading {
      giphys = presenter.list
    }

    let entry = GiphyEntry(giphy: giphys)
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
}

struct GiphyEntryView: View {
  let entry: GiphyProvider.Entry

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack(alignment: .leading) {

        ForEach(Array(entry.giphy.enumerated()), id: \.offset) { _, item in
          GiphyWidgetItem(giphy: item)
            .padding(.horizontal, 5)
        }
      }.padding(.bottom, 60)
      .padding(.horizontal, 10)
    }
  }
}

@main
struct GiphyWidget: Widget {
  private let kind = "GiphyWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: kind,
      provider: GiphyProvider(presenter: WidgetInjection.shared.resolve())
    ) { entry in
      GiphyEntryView(entry: entry)
    }
    .configurationDisplayName("Giphy Widget")
    .description("Show Your Favorites Giphy!")
  }
}

struct GiphyWidget_Previews: PreviewProvider {
  static var previews: some View {
    GiphyEntryView(entry: GiphyEntry(giphy: []))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
