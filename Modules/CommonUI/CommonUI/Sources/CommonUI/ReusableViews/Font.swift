//
//  File.swift
//
//
//  Created by Uwais Alqadri on 10/10/23.
//

import SwiftUI

public enum FontType: String, CaseIterable {
  case bold = "Poppins-Bold"
  case semibold = "Poppins-SemiBold"
  case regular = "Poppins-Regular"
  case medium = "Poppins-Medium"
}

public extension SwiftUI.Text {
  func font(_ type: FontType, size: CGFloat) -> Self {
    font(.custom(type.rawValue, size: size))
  }
}

public extension SwiftUI.View {
  func font(_ type: FontType, size: CGFloat) -> some View {
    font(.custom(type.rawValue, size: size))
  }
}

public extension Font {
  static func loadAllFonts() {
    FontType.allCases.forEach(registerFont)
  }
  
  private static func registerFont(_ fontType: FontType) {
    guard let fontURL = Bundle.common.url(forResource: fontType.rawValue, withExtension: "ttf"),
          let fontData = try? Data(contentsOf: fontURL),
          let dataProvider = CGDataProvider(data: fontData as CFData),
          let font = CGFont(dataProvider) else {
      print("❌ Failed to register font: %@", fontType.rawValue)
      return
    }
    
    var error: Unmanaged<CFError>?
    if !CTFontManagerRegisterGraphicsFont(font, &error) {
      print("⚠️ Font registration failed: %@ (already registered or invalid)", fontType.rawValue)
    } else {
      print("✅ Font successfully registered: %@", fontType.rawValue)
    }
  }
}
