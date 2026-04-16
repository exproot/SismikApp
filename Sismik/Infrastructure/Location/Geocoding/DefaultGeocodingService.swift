//
//  DefaultGeocodingService.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import CoreLocation
import Combine
import Foundation

final class DefaultGeocodingService: GeocodingServiceProtocol {

  func geocode(_ placeName: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
    Future { promise in
      let locale = Locale.preferredLanguages.first.flatMap { Locale(identifier: $0) }
      CLGeocoder().geocodeAddressString(placeName, in: nil, preferredLocale: locale) { placemarks, error in
        if let coordinate = placemarks?.first?.location?.coordinate {
          promise(.success(coordinate))
        } else {
          promise(.failure(error ?? NSError()))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func reverseGeocode(_ coordinate: CLLocationCoordinate2D) -> AnyPublisher<String, Error> {
    Future { promise in
      let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
      let locale = Locale.preferredLanguages.first.flatMap { Locale(identifier: $0) }

      CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
        if let placemark = placemarks?.first {
          let locationName =
          placemark.locality ??
          placemark.subAdministrativeArea ??
          placemark.administrativeArea ??
          placemark.country ??
          NSLocalizedString("explore.geocoding.unknown", comment: "Unknown Location")

          promise(.success(locationName))
        } else {
          promise(.failure(error ?? NSError()))
        }
      }
    }
    .eraseToAnyPublisher()
  }

}
