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
          VStack(alignment: .leading) {
            Text(earthquake.title)
              .font(.headline)

            Text("Mag: \(earthquake.magnitude)")
              .font(.subheadline)
              .foregroundStyle(Color.secondary)
          }
          .onTapGesture {
            viewModel.showEarthquakeDetails?(earthquake)
          }
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
