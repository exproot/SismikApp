//
//  EarthquakeListView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

struct EarthquakeListView: View {

  @ObservedObject var viewModel: DefaultEarthquakeListViewModel

  var body: some View {
    ZStack {
      if viewModel.isLoading {
        ProgressView("Loading...")
          .progressViewStyle(.circular)
      } else if let errorMessage = viewModel.errorMessage {
        VStack {
          Text(errorMessage)
            .font(.headline)
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.center)

          Button {
            viewModel.requestUserLocation()
          } label: {
            Text("Retry")
              .padding()
          }
        }
        .padding()
      } else {
        List(viewModel.earthquakes, id: \.id) { earthquake in
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
          .onTapGesture {
            viewModel.showEarthquakeDetails?(earthquake)
          }
          .padding(.vertical, 8)
        }
        .refreshable {
          viewModel.requestUserLocation()
        }
        .listStyle(.insetGrouped)
      }
    }
    .navigationTitle("Recent Earthquakes")
    .onAppear {
      viewModel.requestUserLocation()
    }
  }
}
