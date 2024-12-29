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
          if let escapedCaption = state.shareCaption.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let fullMessage = "\(escapedCaption)\(imageUtmShare)"
            self.shareImageToWhatsApp(image: state.shareImage, caption: fullMessage)
          }
          
        case .instagram:
          self.postImageToInstagram(state.shareImage, appName: state.appName ?? "-")
          
        case .twitter:
          if let escapedCaption = state.shareCaption.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let fullMessage = "\(escapedCaption)\(imageUtmShare)"
            self.shareImageToTwitter(image: state.shareImage, caption: fullMessage)
          }
          
        case .telegram:
          if let escapedCaption = state.shareCaption.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let fullMessage = "\(escapedCaption)\(imageUtmShare)"
            self.shareImageToTelegram(image: state.shareImage, caption: fullMessage)
          }
          
        case .copy:
          Toaster.success(message: Localizable.labelCopied.tr()).show()
          
        case .more:
          state.showShareSheet.toggle()
        }
        
        return .none
      }
    }
  }
  
  private func shareImageToWhatsApp(image: UIImage, caption: String) {
    let urlWhats = "whatsapp://app"
    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      
      if let whatsappURL = URL(string: urlString) {
        
        if UIApplication.shared.canOpenURL(whatsappURL) {
          
          if let imageData = image.jpegData(compressionQuality: 1.0) {
            let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")!
            do {
              try imageData.write(to: tempFile, options: .atomic)
              let documentController = UIDocumentInteractionController(url: tempFile)
              documentController.uti = "net.whatsapp.image"
              if let contextView = contextView {
                documentController.presentOpenInMenu(from: .zero, in: contextView, animated: true)
              }
            } catch {
              print(error)
            }
          }
          
        } else {
          let ac = UIAlertController(title: "MessageAletTitleText", message: "AppNotFoundToShare", preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OKButtonText", style: .default))
          contextViewController?.present(ac, animated: true)
          print("Whatsapp isn't installed ")
        }
      }
    }
  }
  
  private func postImageToInstagram(_ image: UIImage, appName: String) {
      guard let imageData = image.pngData(),
            let imageURL = saveImageToTemporaryDirectory(imageData: imageData, fileName: "sharedImage.png") else { return }
      
      let instagramUrl = URL(string: "instagram://library?AssetPath=\(imageURL.absoluteString)")!
      if UIApplication.shared.canOpenURL(instagramUrl) {
          UIApplication.shared.open(instagramUrl)
      } else {
          Toaster.error(message: "Instagram app not installed").show()
      }
  }

  private func shareImageToTwitter(image: UIImage, caption: String) {
      guard let imageData = image.jpegData(compressionQuality: 1.0),
            let imageURL = saveImageToTemporaryDirectory(imageData: imageData, fileName: "sharedImage.jpg") else { return }
      
      let twitterUrl = URL(string: "twitter://post?message=\(caption)")!
      if UIApplication.shared.canOpenURL(twitterUrl) {
          UIApplication.shared.open(twitterUrl)
      } else {
          let webUrl = URL(string: "https://twitter.com/intent/tweet?text=\(caption)")!
          UIApplication.shared.open(webUrl)
      }
  }
  
  private func shareImageToTelegram(image: UIImage, caption: String) {
      guard let imageData = image.jpegData(compressionQuality: 1.0),
            let imageURL = saveImageToTemporaryDirectory(imageData: imageData, fileName: "sharedImage.jpg") else { return }
      
      let telegramUrl = URL(string: "tg://msg?text=\(caption)")!
      if UIApplication.shared.canOpenURL(telegramUrl) {
          UIApplication.shared.open(telegramUrl)
      } else {
          Toaster.error(message: "Telegram app not installed").show()
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
  }
  
  var contextViewController: UIViewController? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .compactMap { $0.windows.first { $0.isKeyWindow } }
      .first?.rootViewController.flatMap(getTopViewController)
  }
  
  var contextView: UIView? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .compactMap { $0.windows.first { $0.isKeyWindow } }
      .first?.rootViewController.flatMap(getTopViewController)?.view
  }
  
  func getTopViewController(from viewController: UIViewController) -> UIViewController {
    if let presented = viewController.presentedViewController {
      return getTopViewController(from: presented)
    } else if let navigation = viewController as? UINavigationController {
      return getTopViewController(from: navigation.visibleViewController ?? viewController)
    } else if let tabBar = viewController as? UITabBarController {
      return getTopViewController(from: tabBar.selectedViewController ?? viewController)
    } else {
      return viewController
    }
  }
}
