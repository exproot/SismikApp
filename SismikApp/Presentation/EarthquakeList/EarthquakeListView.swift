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
      content
    }
    .navigationTitle("Recent Earthquakes")
    .onAppear {
      viewModel.requestUserLocation()
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading {
      LoadingView()
    } else if let errorMessage = viewModel.errorMessage {
      ErrorView(message: errorMessage) {
        viewModel.requestUserLocation()
      }
    } else if viewModel.earthquakes.isEmpty {
      EmptyStateView()
    } else {
      EarthquakeList(earthquakes: viewModel.earthquakes) { earthquake in
        viewModel.showEarthquakeDetails?(earthquake)
      } onRefresh: {
        viewModel.requestUserLocation()
      }

    }
  }
}
