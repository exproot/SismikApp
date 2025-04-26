//
//  EarthquakeListViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine
import Foundation

protocol EarthquakeListViewModelInput {
  func fetchEarthquakes(around coordinate: CLLocationCoordinate2D)
}

protocol EarthquakeListViewModelOutput: ObservableObject {
  var earthquakes: [Earthquake] { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get }
}

typealias EarthquakeListViewModel = EarthquakeListViewModelInput & EarthquakeListViewModelOutput

final class DefaultEarthquakeListViewModel: EarthquakeListViewModel {

  @Published private(set) var earthquakes: [Earthquake] = []
  @Published private(set) var isLoading = false
  @Published private(set) var errorMessage: String? = nil

  private var cancellables = Set<AnyCancellable>()
  private let fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol
  private let locationManager: LocationManagerProtocol

  var showLocationDeniedScreen: (() -> Void)?
  var showEarthquakeDetails: ((Earthquake) -> Void)?

  init(
    fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationManager: LocationManagerProtocol,
    showLocationDeniedScreen: @escaping () -> Void,
    showEarthquakeDetails: @escaping (Earthquake) -> Void
  ) {
    self.fetchNearbyEarthquakesUseCase = fetchNearbyEarthquakesUseCase
    self.locationManager = locationManager
    self.showLocationDeniedScreen = showLocationDeniedScreen
    self.showEarthquakeDetails = showEarthquakeDetails
  }

  func fetchEarthquakes(around coordinate: CLLocationCoordinate2D) {
    isLoading = true
    errorMessage = nil

    let minLat = coordinate.latitude - 2.0
    let maxLat = coordinate.latitude + 2.0
    let minLon = coordinate.longitude - 2.0
    let maxLon = coordinate.longitude + 2.0

    fetchNearbyEarthquakesUseCase.execute(minLatitude: minLat, maxLatitude: maxLat, minLongitude: minLon, maxLongitude: maxLon)
      .sink { [weak self] completion in
        guard let self = self else { return }
        self.isLoading = false

        if case .failure = completion {
          self.errorMessage = "Failed to load earthquakes. Please try again."
        }
      } receiveValue: { [weak self] earthquakes in
        self?.earthquakes = earthquakes
      }
      .store(in: &cancellables)

  }

  func requestUserLocation() {
    locationManager.permissionPublisher
      .sink { [weak self] status in
        switch status {
        case .authorized:
          break
        case .denied:
          self?.showLocationDeniedScreen?()
        case .notDetermined:
          break
        }
      }
      .store(in: &cancellables)


    locationManager.locationPublisher
      .sink { [weak self] coordinate in
        self?.fetchEarthquakes(around: coordinate)
      }
      .store(in: &cancellables)

    locationManager.requestLocation()
  }
}
