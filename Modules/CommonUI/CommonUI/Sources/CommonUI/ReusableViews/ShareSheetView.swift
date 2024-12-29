//
//  ShareSheetView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 21/10/23.
//

import SwiftUI

public struct ShareSheetView: UIViewControllerRepresentable {
  public typealias Completion = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
  
  let activityItems: [Any]
  var applicationActivities: [UIActivity]? = nil
  var excludedActivityTypes: [UIActivity.ActivityType]? = nil
  var callback: Completion? = nil
  
  public init(
    activityItems: [Any],
    applicationActivities: [UIActivity]? = nil,
    excludedActivityTypes: [UIActivity.ActivityType]? = nil,
    callback: Completion? = nil
  ) {
    self.activityItems = activityItems
    self.applicationActivities = applicationActivities
    self.excludedActivityTypes = excludedActivityTypes
    self.callback = callback
  }
  
  public func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities)
    controller.excludedActivityTypes = excludedActivityTypes
    controller.completionWithItemsHandler = callback
    return controller
  }
  
  public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    // nothing to do here
  }
}
