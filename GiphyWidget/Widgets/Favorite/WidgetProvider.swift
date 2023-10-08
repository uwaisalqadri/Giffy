//
//  WidgetReducer.swift
//  GiphyWidget
//
//  Created by Uwais Alqadri on 8/10/23.
//

import WidgetKit
import SwiftUI
import Core
import Giphy
import SDWebImageSwiftUI

typealias WidgetInteractor = Interactor<
  String, [Giphy], FavoriteGiphysRepository<
    GiphyLocalDataSource
  >
>

struct WidgetProvider: IntentTimelineProvider {
  private let useCase: WidgetInteractor
  
  init(useCase: WidgetInteractor) {
    self.useCase = useCase
  }
  
  private var sampleEntry: GiphyEntry {
    var giphy = Giphy()
    giphy.url = "https://media4.giphy.com/media/loLO30j5PEbLgAqt63/giphy.gif"
    return GiphyEntry(giphy: giphy)
  }

  func placeholder(in context: Context) -> GiphyEntry {
    sampleEntry
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (GiphyEntry) -> Void) {
    completion(sampleEntry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<GiphyEntry>) -> Void) {
    
    Task {
      do {
        let response = try await self.useCase.execute(request: "")
        if let item = response.first {
          let entries = [GiphyEntry(giphy: item)]
          let timeline = Timeline(entries: entries, policy: .atEnd)
          completion(timeline)
          print("WIDGET:", timeline)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
