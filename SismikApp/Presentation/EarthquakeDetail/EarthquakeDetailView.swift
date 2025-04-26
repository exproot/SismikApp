//
//  EarthquakeDetailView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

struct EarthquakeDetailView: View {

  @ObservedObject var viewModel: EarthquakeDetailViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text(viewModel.title)
          .font(.title)
          .fontWeight(.bold)
          .padding(.bottom, 8)

        Text(viewModel.magnitudeText)
          .font(.headline)

        Text(viewModel.timeText)
          .font(.subheadline)
          .foregroundColor(.secondary)

        Divider()

        Text(viewModel.locationText)
          .font(.body)

        Text(viewModel.depthText)
          .font(.body)

        Spacer()
      }
      .padding()
    }
    .navigationTitle("Details")
  }
}

#Preview {
  EarthquakeDetailView(viewModel: EarthquakeDetailViewModel(earthquake: Earthquake.sampleEarthquake))
}



