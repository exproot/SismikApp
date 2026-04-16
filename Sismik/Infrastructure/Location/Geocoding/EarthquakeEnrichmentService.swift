//
//  EarthquakeEnrichmentService.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import Combine
import CoreLocation
import Foundation

final class EarthquakeEnrichmentService: EarthquakeEnrichmentServiceProtocol {

  private let geocoder: GeocodingServiceProtocol
  private var cache: [Coordinate: String] = [:]

  init(geocoder: GeocodingServiceProtocol) {
    self.geocoder = geocoder
  }

  func enrich(earthquakes: [Earthquake]) -> AnyPublisher<[EnrichedEarthquake], Never> {
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
