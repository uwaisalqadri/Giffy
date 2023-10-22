//
//  WidgetBundle.swift
//  GiphyWidget
//
//  Created by Uwais Alqadri on 22/10/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
  var body: some Widget {
    GiphyWidget()
    GiphyActivityWidget()
  }
}
