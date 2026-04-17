//
//  DefaultLocationManager.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine

public final class DefaultLocationManager: NSObject {

  private let locationManager = CLLocationManager()
  private let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
  private let permissionSubject = PassthroughSubject<LocationPermissionStatus, Never>()

  public override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }

}

// MARK: LocationManager
extension DefaultLocationManager: LocationManagerProtocol {
  public var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  public var permissionPublisher: AnyPublisher<LocationPermissionStatus, Never> {
    permissionSubject.eraseToAnyPublisher()
  }

  public func requestLocation() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      permissionSubject.send(.denied)
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.requestLocation()
    @unknown default:
      permissionSubject.send(.denied)
    }
  }
}

// MARK: CLLocationManagerDelegate
extension DefaultLocationManager: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.first?.coordinate else { return }

    locationSubject.send(coordinate)
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print("LocationManager Error: \(error.localizedDescription)")
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      permissionSubject.send(.notDetermined)
    case .restricted, .denied:
      permissionSubject.send(.denied)
    case .authorizedAlways, .authorizedWhenInUse:
      permissionSubject.send(.authorized)
      locationManager.requestLocation()
    @unknown default:
      permissionSubject.send(.denied)
    }
  }
}
