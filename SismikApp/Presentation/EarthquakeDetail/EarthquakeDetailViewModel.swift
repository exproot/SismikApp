//
//  EarthquakeDetailViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import MapKit
import SwiftUI

final class EarthquakeDetailViewModel: ObservableObject {
  let quake: Earthquake
  let title: String
  let magnitudeText: String
  let timeText: String
  let locationText: String
  let depthText: String
  let coordinate: CLLocationCoordinate2D
  let magnitudeColor: Color

  var showEarthquakeMap: (([Earthquake], Double) -> Void)?

  var searchRadiusKm: Double {
    let query = EarthquakeQuery.loadFromDefaults() ?? EarthquakeQuery.defaultAround(coordinate)

    if let radiusKm = query.radiusKm {
      return radiusKm
    }

    return 222.0
  }

  init(earthquake: Earthquake, showEarthquakeMap: @escaping ([Earthquake], Double) -> Void) {
    quake = earthquake
    title = earthquake.title
    magnitudeText = "Magnitude: \(String(format: "%.1f", earthquake.magnitude))"
    timeText = earthquake.time.formatEarthquakeDate()
    locationText = "Location: \(String(format: "%.3f", earthquake.latitude)), \(String(format: "%.3f", earthquake.longitude))"
    depthText = "Depth: \(String(format: "%1.f", earthquake.depth)) km"
    coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
    magnitudeColor = earthquake.magnitude.magnitudeColor()
    self.showEarthquakeMap = showEarthquakeMap
  }


}
