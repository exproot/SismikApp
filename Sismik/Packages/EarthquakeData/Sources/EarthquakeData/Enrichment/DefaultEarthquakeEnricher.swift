//
//  DefaultEarthquakeEnricher.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import Combine
import CoreLocation
import EarthquakeDomain
import LocationServices

struct Coordinate: Hashable {
  let latitude: Double
  let longitude: Double

  init(_ coordinate: CLLocationCoordinate2D) {
    latitude = coordinate.latitude
    longitude = coordinate.longitude
  }

  var clLocationCoordinate2D: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }

  static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

public final class DefaultEarthquakeEnricher: EarthquakeEnriching {

  private let geocoder: GeocodingServiceProtocol
  private var cache: [Coordinate: String] = [:]

  public init(geocoder: GeocodingServiceProtocol) {
    self.geocoder = geocoder
  }

  public func enrich(earthquakes: [Earthquake]) -> AnyPublisher<[EnrichedEarthquake], Never> {
    let publishers = earthquakes.map { quake in
      let coordinate = Coordinate(CLLocationCoordinate2D(latitude: quake.latitude, longitude: quake.longitude))

      if let cached = cache[coordinate] {
        return Just(EnrichedEarthquake(earthquake: quake, locationName: cached))
          .eraseToAnyPublisher()
      }

      return geocoder.reverseGeocode(coordinate.clLocationCoordinate2D)
        .replaceError(with: NSLocalizedString("explore.geocoding.error", comment: ""))
        .handleEvents(receiveOutput: { [weak self] placeName in
          self?.cache[coordinate] = placeName
        })
        .map { EnrichedEarthquake(earthquake: quake, locationName: $0) }
        .eraseToAnyPublisher()
    }

    return Publishers.MergeMany(publishers)
      .collect()
      .eraseToAnyPublisher()
  }

}
