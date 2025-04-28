//
//  EarthquakePopupView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import SwiftUI

struct EarthquakePopupView: View {

  let earthquake: Earthquake

  var body: some View {
    VStack(spacing: 8) {
      Text(earthquake.title)
        .font(.headline)
        .multilineTextAlignment(.center)

      Text("Magnitude: \(String(format: "%.1f", earthquake.magnitude))")
        .font(.subheadline)
        .foregroundStyle(earthquake.magnitude.magnitudeColor())

      Text(earthquake.time.formatEarthquakeDate())
        .font(.caption)
        .foregroundStyle(Color.secondary)
    }
    .padding()
    .background(.thinMaterial)
    .clipShape(.rect(cornerRadius: 12))
    .shadow(radius: 5)
  }
}

#Preview {
  EarthquakePopupView(earthquake: Earthquake.sampleEarthquake)
}
