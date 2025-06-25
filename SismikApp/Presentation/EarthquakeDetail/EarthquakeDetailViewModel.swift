//
//  EarthquakeDetailViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import MapKit
import SwiftUI

final class EarthquakeDetailViewModel: ObservableObject {

  private let queryStore: EarthquakeQueryStoring

  let quake: Earthquake
  let title: String
  let magnitudeText: String
  let timeText: String
  let locationText: String
  let depthText: String
  let coordinate: CLLocationCoordinate2D
  let magnitudeColor: Color

  var showEarthquakeMap: (([Earthquake], Double, CLLocationCoordinate2D) -> Void)?

  var searchRadiusKm: Double {
    let query = queryStore.load() ?? EarthquakeQuery.defaultAround(coordinate)

    if let radiusKm = query.radiusKm {
      return radiusKm
    }

    return 222.0
  }

  var userCoordinate: CLLocationCoordinate2D {
    if let query = queryStore.load(),
       let lat = query.latitude,
       let lon = query.longitude
    {
      return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    return CLLocationCoordinate2D(latitude: 35.0, longitude: 26.0)
  }

  init(
    earthquake: Earthquake,
    queryStore: EarthquakeQueryStoring,
    showEarthquakeMap: @escaping ([Earthquake], Double, CLLocationCoordinate2D) -> Void
  ) {
    self.queryStore = queryStore
    quake = earthquake
    title = earthquake.title
    magnitudeText = String(
      format: NSLocalizedString("detail.magnitude", comment: ""),
      earthquake.magnitude
    )

    locationText = String(
      format: NSLocalizedString("detail.location", comment: ""),
      earthquake.latitude,
      earthquake.longitude
    )

    depthText = String(
      format: NSLocalizedString("detail.depth", comment: ""),
      earthquake.depth
    )

    timeText = earthquake.time.formatEarthquakeDate()

    coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
    magnitudeColor = earthquake.magnitude.magnitudeColor()
    self.showEarthquakeMap = showEarthquakeMap
  }

}
