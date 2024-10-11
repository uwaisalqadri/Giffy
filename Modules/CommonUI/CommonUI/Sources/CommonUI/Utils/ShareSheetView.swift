//
//  ShareSheetView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 21/10/23.
//

import SwiftUI

public struct ShareSheetView: UIViewControllerRepresentable {
  typealias Completion = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
  
  let activityItems: [Any]
  let applicationActivities: [UIActivity]? = nil
  let excludedActivityTypes: [UIActivity.ActivityType]? = nil
  let callback: Completion? = nil
  
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
