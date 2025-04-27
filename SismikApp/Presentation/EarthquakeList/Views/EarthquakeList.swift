//
//  EarthquakeList.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import SwiftUI

struct EarthquakeList: View {

  let earthquakes: [Earthquake]
  let onSelect: (Earthquake) -> Void
  let onRefresh: () -> Void

  var body: some View {
    List(earthquakes, id: \.id) { earthquake in
      VStack(alignment: .leading, spacing: 8) {
        Text(earthquake.title)
          .font(.headline)

        Text("Mag: \(String(format: "%.1f", earthquake.magnitude))")
          .font(.subheadline)
          .foregroundStyle(earthquake.magnitude.magnitudeColor())

        Text(earthquake.time.formatEarthquakeDate())
          .font(.caption)
          .foregroundColor(.gray)
      }
      .padding(.vertical, 8)
      .onTapGesture {
        onSelect(earthquake)
      }
    }
    .listStyle(.insetGrouped)
    .refreshable {
      onRefresh()
    }
  }

}
