//
//  DefaultLocationManager.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine

enum LocationPermissionStatus {
  case authorized
  case denied
  case notDetermined
}

final class DefaultLocationManager: NSObject {

  private let locationManager = CLLocationManager()
  private let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
  private let permissionSubject = PassthroughSubject<LocationPermissionStatus, Never>()

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }

}

// MARK: LocationManager
extension DefaultLocationManager: LocationManagerProtocol {
  var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  var permissionPublisher: AnyPublisher<LocationPermissionStatus, Never> {
    permissionSubject.eraseToAnyPublisher()
  }

  func requestLocation() {
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
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.first?.coordinate else { return }

    locationSubject.send(coordinate)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print("LocationManager Error: \(error.localizedDescription)")
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
