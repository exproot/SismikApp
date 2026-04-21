//
//  EarthquakeMapViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import EarthquakeDomain
import MapKit

public struct EarthquakeMapContext {
  public let earthquakes: [Earthquake]
  public let searchRadius: Double?
  public let center: CLLocationCoordinate2D
  
  public init(
    earthquakes: [Earthquake],
    radius: Double?,
    center: CLLocationCoordinate2D
  ) {
    self.earthquakes = earthquakes
    self.searchRadius = radius
    self.center = center
  }
}

final class EarthquakeMapViewModel: ObservableObject {
  
  private let context: EarthquakeMapContext

  @Published var earthquakes: [Earthquake]
  @Published var selectedEarthquake: Earthquake?
  @Published var region: MKCoordinateRegion
  @Published var boundingOverlay: MKCircle?

  private let mapRegionProvider: EarthquakeMapRegionProvider

  init(
    context: EarthquakeMapContext,
    mapRegionProvider: EarthquakeMapRegionProvider = EarthquakeMapRegionProvider(),
  ) {
    self.context = context
    self.earthquakes = context.earthquakes
    self.mapRegionProvider = mapRegionProvider
    self.region = mapRegionProvider.region(for: context.earthquakes)
    
    if let radius = context.searchRadius {
      let radiusInMeters = radius * 1000
      self.boundingOverlay = MKCircle(center: context.center, radius: radiusInMeters)
    }
  }

  func earthquake(matching coordinate: CLLocationCoordinate2D) -> Earthquake? {
    earthquakes.first {
      abs($0.latitude - coordinate.latitude) < 0.0001 &&
      abs($0.longitude - coordinate.longitude) < 0.0001
    }
  }

}
