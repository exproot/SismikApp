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
      CLGeocoder().geocodeAddressString(placeName) { placemarks, error in
        if let coordinate = placemarks?.first?.location?.coordinate {
          promise(.success(coordinate))
        } else {
          promise(.failure(error ?? NSError()))
        }
      }
    }
    .eraseToAnyPublisher()
  }

}
