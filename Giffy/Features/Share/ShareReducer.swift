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
    var shareImage: UIImage {
      if let image = image, let cachedImage = UIImage(data: image) {
        return cachedImage
      }
      return UIImage()
    }
    var shareCaption: String {
      "Product Caption"
    }
    var appName: String? {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    var utmFormat: String = "?utm_source=%@&utm_medium=social&utm_campaign=product_share"
    
    var image: Data?
    init(_ image: Data?) {
      self.image = image
    }
  }
  
  public enum Action {
    case onShare(ShareType)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onShare(type):
        let imageUtmShare = String(format: state.utmFormat, type.rawValue)

        switch type {
        case .whatsapp:
          let escapedString = state.shareCaption.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
          guard let actionUrl = URL(string: "https://wa.me/?text=\(escapedString)\(imageUtmShare)") else { return .none }
          self.shareTo(url: actionUrl, with: ShareType.whatsapp.rawValue)
          
        case .instagram:
          self.postImageToInstagram(state.shareImage, appName: state.appName ?? "-")
          
        case .twitter:
          let escapedString = state.shareCaption.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
          guard let appUrl = URL(string: "twitter://post?message=\(escapedString)\(imageUtmShare)") else { return .none }
          
          if UIApplication.shared.canOpenURL(appUrl) {
            self.shareTo(url: appUrl, with: ShareType.twitter.rawValue)
          } else {
            guard let webUrl = URL(string: "https://twitter.com/intent/tweet?text=\(escapedString)\(imageUtmShare)") else { return .none }
            UIApplication.shared.open(webUrl)
          }
          
        case .telegram:
          let escapedString = state.shareCaption.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
          guard let url = URL(string: "tg://msg?text=\(escapedString)\(imageUtmShare)") else { return .none }
          self.shareTo(url: url, with: ShareType.telegram.rawValue)
          
        case .copy:
          Toaster.success(message: Localizable.labelCopied.tr()).show()
          
        case .more:
          state.showShareSheet.toggle()
          
        }
        return .none
      }
    }
  }
  
  func postImageToInstagram(_ image: UIImage, appName: String) {
    if UIApplication.shared.canOpenURL(URL(string: "instagram://app")!) {
      PHPhotoLibrary.requestAuthorization { [weak self] status in
        guard let self = self else { return }
        
        if status == .authorized {
          UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
          Toaster.error(message: "\(appName) membutuhkan izin anda untuk menulis file ke Photo Library").show()
        }
      }
    } else {
      Toaster.error(message: "Instagram (X app) tidak terinstal").show()
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if error != nil {
      Toaster.error(message: "Gagal menyimpan gambar, cek storage iphone kamu.").show()
      return
    }
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    fetchOptions.fetchLimit = 1
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    if let lastAsset = fetchResult.firstObject {
      let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        Toaster.error(message: "Instagram (X app) tidak terinstal").show()
      }
    }
  }
  
  private func shareTo(url: URL, with name: String) {
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      Toaster.error(message: "\(name) tidak terinstal.").show()
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
  }
}
