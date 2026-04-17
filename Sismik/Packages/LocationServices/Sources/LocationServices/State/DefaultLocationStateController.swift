//
//  DefaultLocationStateController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import CoreLocation
import Combine

public final class DefaultLocationStateController: LocationStateControlling {

  private let locationManager: LocationManagerProtocol
  private var cancellables = Set<AnyCancellable>()

  private let authSubject = CurrentValueSubject<LocationPermissionStatus, Never>(.notDetermined)
  private let coordinateSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()

  public var authorizationStatusPublisher: AnyPublisher<LocationPermissionStatus, Never> {
    authSubject.eraseToAnyPublisher()
  }

  public var coordinatePublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
    coordinateSubject.eraseToAnyPublisher()
  }

  public init(locationManager: LocationManagerProtocol) {
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

  public func requestLocation() {
    locationManager.requestLocation()
  }
  
}
