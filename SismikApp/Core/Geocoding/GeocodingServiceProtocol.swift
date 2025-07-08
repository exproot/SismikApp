//
//  GeocodingServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import CoreLocation
import Combine
import Foundation

protocol GeocodingServiceProtocol {
  func geocode(_ placeName: String) -> AnyPublisher<CLLocationCoordinate2D, Error>
}
