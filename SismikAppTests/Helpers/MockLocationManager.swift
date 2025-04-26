//
//  MockLocationManager.swift
//  SismikAppTests
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import CoreLocation
@testable import SismikApp

final class MockLocationManager: LocationManagerProtocol {

  private let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
  private let permissionSubject = PassthroughSubject<LocationPermissionStatus, Never>()

  var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  var permissionPublisher: AnyPublisher<SismikApp.LocationPermissionStatus, Never> {
    return permissionSubject.eraseToAnyPublisher()
  }

  func simulateLocation(coordinate: CLLocationCoordinate2D) {
    locationSubject.send(coordinate)
  }

  func simulatePermission(_ status: LocationPermissionStatus) {
    permissionSubject.send(status)
  }

  func requestLocation() {
    // No-op
  }

}
