//
//  EarthquakeList.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import SwiftUI

struct EarthquakeList: View {

  let earthquakes: [Earthquake]
  let summaryText: String

  let onSelect: (Earthquake) -> Void
  let onRefresh: () -> Void

  var body: some View {

    List {
      if !summaryText.isEmpty {
        Section {
          ForEach(earthquakes) { earthquake in
            cell(for: earthquake)
          }
        } header: {
          FilterSummaryBannerView(text: summaryText)
        }
      } else {
        ForEach(earthquakes) { earthquake in
          cell(for: earthquake)
        }
      }
    }
    .listStyle(.insetGrouped)
    .refreshable {
      onRefresh()
    }
  }

  private func cell(for earthquake: Earthquake) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(earthquake.title)
        .font(.headline)

      Text("\(NSLocalizedString("earthquakes.magnitude", comment: "")): \(String(format: "%.1f", earthquake.magnitude))")
        .font(.subheadline)
        .foregroundStyle(earthquake.magnitude.magnitudeColor())

      Text(earthquake.time.formatEarthquakeDate())
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 8)
    .onTapGesture {
      onSelect(earthquake)
    }
  }

}
