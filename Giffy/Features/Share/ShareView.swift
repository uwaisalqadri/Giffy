//
//  ShareView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 22/12/24.
//

import SwiftUI
import Core
import Common
import CommonUI
import ComposableArchitecture

struct ShareView: View {
  let store: StoreOf<ShareReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text("Oke")
    }
  }
}
