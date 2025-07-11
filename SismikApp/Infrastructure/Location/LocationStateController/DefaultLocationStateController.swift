//
//  DefaultLocationStateController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import CoreLocation
import Combine

final class DefaultLocationStateController: LocationStateControlling {

  private let locationManager: LocationManagerProtocol
  private var cancellables = Set<AnyCancellable>()

  private let authSubject = CurrentValueSubject<LocationPermissionStatus, Never>(.notDetermined)
  private let coordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()

  var authorizationStatusPublisher: AnyPublisher<LocationPermissionStatus, Never> {
    authSubject.eraseToAnyPublisher()
  }

  var coordinatePublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
    coordinateSubject.eraseToAnyPublisher()
  }

  init(locationManager: LocationManagerProtocol) {
    self.locationManager = locationManager
    bindToLocationManager()
  }

  private func bindToLocationManager() {
    locationManager.permissionPublisher
      .sink { [weak self] status in
        self?.authSubject.send(status)
      }
      .store(in: &cancellables)

    locationManager.locationPublisher
      .sink { [weak self] coordinate in
        self?.coordinateSubject.send(coordinate)
      }
      .store(in: &cancellables)
  }

  func requestLocation() {
    locationManager.requestLocation()
  }
  
}
