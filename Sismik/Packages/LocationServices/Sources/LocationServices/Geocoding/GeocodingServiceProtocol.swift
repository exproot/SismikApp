//
//  GeocodingServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import CoreLocation
import Combine

public protocol GeocodingServiceProtocol {
  func geocode(_ placeName: String) -> AnyPublisher<CLLocationCoordinate2D, Error>
  func reverseGeocode(_ coordinate: CLLocationCoordinate2D) -> AnyPublisher<String, Error>
}
