//
//  ShareReducer.swift
//  Giffy
//
//  Created by Uwais Alqadri on 22/12/24.
//

import ComposableArchitecture
import Common
import CommonUI
import Foundation
import SwiftUI
import Social
import MessageUI
import Photos

@Reducer
public class ShareReducer {
  
  @Route var router
  
  @ObservableState
  public struct State: Equatable {
    var topItems: [ShareType] = [.whatsapp, .instagram, .twitter, .telegram]
    var bottomItems: [ShareType] = [.copy, .more]
    var showShareSheet: Bool = false
    var excludedShareApps: [UIActivity.ActivityType]?
    var shareCaption: String {
      "Product Caption"
    }
    var appName: String? {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var shareImageURL: URL?
    var imageData: Data?
    init(_ imageData: Data?) {
      self.imageData = imageData
    }
  }
  
  public enum Action {
    case onShare(ShareType)
    case dismissShare
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onShare(type):
        state.excludedShareApps = type.excludedActivities
        switch type {
        case .whatsapp, .telegram:
          self.shareImageGIF(imageData: state.imageData) { url in
            state.shareImageURL = url
            state.showShareSheet = true
          }
          
        case .twitter:
          self.shareImageGIF(imageData: state.imageData) { url in
            state.shareImageURL = url
            state.showShareSheet = true
          }
          
        case .instagram:
          self.postImageToInstagram(state.imageData)
          
        case .copy:
          state.imageData?.copyGifClipboard()
          state.showShareSheet = false
          Toaster.success(message: Localizable.labelCopied.tr()).show()
          
        case .more:
          self.shareImageGIF(imageData: state.imageData) { url in
            state.shareImageURL = url
            state.showShareSheet = true
          }
        }
        return .none
        
      case .dismissShare:
        state.showShareSheet = false
        return .none
      }
    }
  }
  
  private func shareImageGIF(imageData: Data?, onShare: (URL?) -> Void) {
    if let data = imageData,
       let imageURL = self.saveImageToTemporaryDirectory(imageData: data, fileName: "Giffy.gif") {
      onShare(imageURL)
    }
  }

  private func postImageToInstagram(_ imageData: Data?) {
    guard let imageData = imageData else {
      return
    }
    
    PHPhotoLibrary.requestAuthorization { status in
      guard status == .authorized else {
        return
      }
      
      self.saveImageToPhotoLibrary(imageData: imageData) { localIdentifier in
        guard let localIdentifier = localIdentifier else {
          return
        }
        
        let instagramUrl = URL(string: "instagram://library?LocalIdentifier=\(localIdentifier)")!
        
        DispatchQueue.main.async {
          if UIApplication.shared.canOpenURL(instagramUrl) {
            UIApplication.shared.open(instagramUrl)
          } else {
            print("Instagram app not installed")
          }
        }
      }
    }
  }
  
  private func saveImageToPhotoLibrary(imageData: Data, completion: @escaping (String?) -> Void) {
    PHPhotoLibrary.shared().performChanges {
      let request = PHAssetCreationRequest.forAsset()
      let options = PHAssetResourceCreationOptions()
      request.addResource(with: .photo, data: imageData, options: options)
    } completionHandler: { success, _ in
      if success {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
          completion(lastAsset.localIdentifier)
        } else {
          completion(nil)
        }
      } else {
        completion(nil)
      }
    }
  }
  
  private func saveImageToTemporaryDirectory(imageData: Data, fileName: String) -> URL? {
    let temporaryDirectory = FileManager.default.temporaryDirectory
    let fileURL = temporaryDirectory.appendingPathComponent(fileName)
    
    do {
      try imageData.write(to: fileURL)
      return fileURL
    } catch {
      print("Error saving image to temporary directory: \(error)")
      return nil
    }
  }
}

public extension ShareReducer {
  enum ShareType {
    case whatsapp
    case instagram
    case twitter
    case telegram
    case copy
    case more
    
    var id: String {
      UUID().uuidString
    }
    
    var rawValue: String {
      switch self {
      case .whatsapp:
        return "whatsapp"
      case .instagram:
        return "instagram"
      case .twitter:
        return "twitter"
      case .telegram:
        return "telegram"
      case .copy:
        return "copy"
      case .more:
        return "more"
      }
    }
    
    var excludedActivities: [UIActivity.ActivityType]? {
      switch self {
      case .whatsapp, .telegram:
        return [.postToFacebook, .postToTwitter, .airDrop, .copyToPasteboard, .markupAsPDF, .message, .saveToCameraRoll]
      case .twitter:
        return [.postToFacebook, .airDrop, .copyToPasteboard, .markupAsPDF, .message, .saveToCameraRoll]
      case .instagram:
        return nil
      case .copy, .more:
        return nil
      }
    }
  }
}
