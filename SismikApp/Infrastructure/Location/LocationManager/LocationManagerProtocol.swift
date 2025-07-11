//
//  LocationManagerProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import CoreLocation
import Combine

protocol LocationManagerProtocol {
  var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Never> { get }
  var permissionPublisher: AnyPublisher<LocationPermissionStatus, Never> { get }

  func requestLocation()
}
