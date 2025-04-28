//
//  EarthquakePinView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import SwiftUI

struct EarthquakePinView: View {

  let magnitude: Double

  var body: some View {
    Text(String(format: "%.1f", magnitude))
      .font(.caption.bold())
      .foregroundStyle(Color.white)
      .frame(width: 40, height: 40)
      .background(magnitude.magnitudeColor())
      .clipShape(Circle())
      .overlay {
        Circle()
          .stroke(Color.white, lineWidth: 2)
      }
  }
}

#Preview {
  EarthquakePinView(magnitude: 4.4)
}
