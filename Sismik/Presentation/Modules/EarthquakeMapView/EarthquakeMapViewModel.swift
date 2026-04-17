//
//  EarthquakeMapViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import EarthquakeDomain
import MapKit

final class EarthquakeMapViewModel: ObservableObject {

  @Published var earthquakes: [Earthquake]
  @Published var selectedEarthquake: Earthquake?
  @Published var region: MKCoordinateRegion
  @Published var boundingOverlay: MKCircle?

  private let mapRegionProvider: MapRegionProviding

  init(
    earthquakes: [Earthquake],
    mapRegionProvider: MapRegionProviding,
    searchRadiusKm: Double,
    centerCoordinate: CLLocationCoordinate2D
  ) {
    self.earthquakes = earthquakes
    self.mapRegionProvider = mapRegionProvider
    self.region = mapRegionProvider.region(for: earthquakes)

    let radiusInMeters = searchRadiusKm * 1000
    self.boundingOverlay = MKCircle(center: centerCoordinate, radius: radiusInMeters)
  }

  func earthquake(matching coordinate: CLLocationCoordinate2D) -> Earthquake? {
    earthquakes.first {
      abs($0.latitude - coordinate.latitude) < 0.0001 &&
      abs($0.longitude - coordinate.longitude) < 0.0001
    }
  }

}
