//
//  LocationAccessView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

struct LocationAccessView: View {
  var body: some View {
    VStack(spacing: 16) {
      Text("Location Required")
        .font(.headline)
        .bold()

      Text("We need your location to show nearby earthquakes.")
        .font(.subheadline)

      Button {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
          if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
          }
        }
      } label: {
        Text("Open Settings")
      }
    }
    .padding()
  }
}

#Preview {
  LocationAccessView()
}
