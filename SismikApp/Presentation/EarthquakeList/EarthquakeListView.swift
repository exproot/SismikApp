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
    .navigationTitle(NSLocalizedString("earthquakes.navigation.title", comment: ""))
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          if let coordinate = viewModel.lastCoordinate {
            viewModel.showEarthquakeMap?(viewModel.earthquakes, viewModel.searchRadiusKm, coordinate)
          }
        } label: {
          Image(systemName: "map")
        }
      }

      ToolbarItem(placement: .topBarTrailing) {
        Button {
          viewModel.showFilter()
        } label: {
          Image(systemName: "line.3.horizontal.decrease.circle")
        }
      }
    }
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
      if let summary = viewModel.filterSummaryText {
        EarthquakeList(earthquakes: viewModel.earthquakes, summaryText: summary) { earthquake in
          viewModel.showEarthquakeDetails?(earthquake)
        } onRefresh: {
          viewModel.requestUserLocation()
        }
      }
    }
  }
}
