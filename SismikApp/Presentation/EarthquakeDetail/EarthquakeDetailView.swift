//
//  EarthquakeDetailView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import MapKit
import SwiftUI

struct EarthquakeDetailView: View {

  @ObservedObject var viewModel: EarthquakeDetailViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        // Title
        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.title)
            .font(.title2.bold())

          Label(viewModel.magnitudeText, systemImage: "waveform.path.ecg")
            .foregroundStyle(viewModel.magnitudeColor)
        }

        Divider()

        // Info Section
        VStack(alignment: .leading, spacing: 12) {
          Label(viewModel.locationText, systemImage: "location.fill")
          Label(viewModel.depthText, systemImage: "arrow.down.to.line")
          Label(viewModel.timeText, systemImage: "clock")
        }
        .font(.body)

        Divider()

        MiniMapViewWrapper(earthquake: viewModel.quake)
          .frame(height: 200)
          .onTapGesture {
            viewModel.showEarthquakeMap?([viewModel.quake], viewModel.searchRadiusKm)
          }
      }
      .padding()
    }
    .navigationTitle("Details")
  }
}



