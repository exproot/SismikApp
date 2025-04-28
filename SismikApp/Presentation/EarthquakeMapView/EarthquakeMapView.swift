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

    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.earthquakes) { earthquake in
      MapMarker(
        coordinate: CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude),
        tint: .red
      )
    }
    .navigationTitle("Earthquake Map")
  }
}

