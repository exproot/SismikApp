//
//  EarthquakeDetailViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import MapKit

final class EarthquakeDetailViewModel {

  // MARK: Dependencies
  private let queryStore: EarthquakeQueryStoring

  // MARK: Input
  let quake: Earthquake

  // MARK: Output
  let title: String
  let magnitudeText: String
  let timeText: String
  let locationText: String
  let depthText: String
  let coordinate: CLLocationCoordinate2D
  let magnitudeColor: UIColor

  // MARK: Callback
  var showEarthquakeMap: (([Earthquake], Double, CLLocationCoordinate2D) -> Void)?

  // MARK: Init
  init(
    earthquake: Earthquake,
    queryStore: EarthquakeQueryStoring,
    showEarthquakeMap: @escaping ([Earthquake], Double, CLLocationCoordinate2D) -> Void
  ) {
    self.queryStore = queryStore
    self.showEarthquakeMap = showEarthquakeMap
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

    magnitudeColor = earthquake.magnitude.magnitudeColor()

    timeText = earthquake.time.formatEarthquakeDate()
    coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
  }

  // MARK: Helpers
  var searchRadiusKm: Double {
    let query = queryStore.load() ?? EarthquakeQuery.defaultAround(coordinate)

    return query.radiusKm ?? 222.0
  }

  var userCoordinate: CLLocationCoordinate2D {
    guard
      let query = queryStore.load(),
      let lat = query.latitude,
      let lon = query.longitude
    else {
      return CLLocationCoordinate2D(latitude: 35.0, longitude: 26.0)
    }

    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }

}
