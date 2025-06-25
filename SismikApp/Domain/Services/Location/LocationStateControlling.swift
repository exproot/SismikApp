//
//  LocationStateControlling.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import CoreLocation
import Combine

protocol LocationStateControlling {
  var authorizationStatusPublisher: AnyPublisher<LocationPermissionStatus, Never> { get }
  var coordinatePublisher: AnyPublisher<CLLocationCoordinate2D, Never> { get }

  func requestLocation()
}
