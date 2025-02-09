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
    guard let fontPath = Bundle.common.path(forResource: fontType.rawValue, ofType: "ttf"),
          let fontData = NSData(contentsOfFile: fontPath),
          let dataProvider = CGDataProvider(data: fontData),
          let font = CGFont(dataProvider) else {
      print("Failed to register font: \(fontType.rawValue)")
      return
    }
    
    var error: Unmanaged<CFError>?
    if !CTFontManagerRegisterGraphicsFont(font, &error) {
      print("Font registration failed: \(fontType.rawValue) (already registered or invalid)")
    }
  }
}
