//
//  WidgetReducer.swift
//  GiffyWidget
//
//  Created by Uwais Alqadri on 8/10/23.
//

import WidgetKit
import SwiftUI
import Core
import Common

typealias FavoriteWidgetUseCase = Interactor<
  String, [Giffy], FavoriteGiphysInteractor<
    FavoriteLocalDataSource
  >
>

struct GiffyEntry: TimelineEntry {
  var date = Date()
  let total: Int
}

struct WidgetProvider: TimelineProvider {
  @AppStorage("copyCount", store: UserDefaults(suiteName: "com.uwaisalqadri.giffo")) var copyCount: Int = 0
  
  func placeholder(in context: Context) -> GiffyEntry {
    GiffyEntry(total: copyCount)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (GiffyEntry) -> Void) {
    let entry = GiffyEntry(total: copyCount)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<GiffyEntry>) -> Void) {
    let entry = GiffyEntry(total: copyCount)
    let currentDate = Date()
    let futureDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
    let timeline = Timeline(entries: [entry], policy: .after(futureDate))
    completion(timeline)
  }
}
