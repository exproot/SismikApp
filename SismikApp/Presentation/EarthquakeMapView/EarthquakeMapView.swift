//
//  EarthquakeMapView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import MapKit
import SwiftUI

struct EarthquakeMapView: View {

  @ObservedObject var viewModel: EarthquakeMapViewModel

  var body: some View {
    ZStack {
      Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.earthquakes) { earthquake in
        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)) {
          EarthquakePinView(magnitude: earthquake.magnitude)
            .highPriorityGesture(
              TapGesture()
                .onEnded {
                  viewModel.selectedEarthquake = earthquake
                }
            )
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        viewModel.selectedEarthquake = nil
      }
      .ignoresSafeArea()

      if let selectedEarthquake = viewModel.selectedEarthquake {
        VStack {
          Spacer()

          EarthquakePopupView(earthquake: selectedEarthquake)
            .padding()
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.4), value: viewModel.selectedEarthquake)
        }
      }
    }
  }
}

