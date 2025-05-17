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
  var showEarthquakeMap: (([Earthquake]) -> Void)?

  init(
    fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationManager: LocationManagerProtocol,
    showLocationDeniedScreen: @escaping () -> Void,
    showEarthquakeDetails: @escaping (Earthquake) -> Void,
    showEarthquakeMap: @escaping ([Earthquake]) -> Void
  ) {
    self.fetchNearbyEarthquakesUseCase = fetchNearbyEarthquakesUseCase
    self.locationManager = locationManager
    self.showLocationDeniedScreen = showLocationDeniedScreen
    self.showEarthquakeDetails = showEarthquakeDetails
    self.showEarthquakeMap = showEarthquakeMap
  }

  func fetchEarthquakes(around coordinate: CLLocationCoordinate2D) {
    isLoading = true
    errorMessage = nil

    let query = EarthquakeQuery.defaultAround(coordinate)

    fetchNearbyEarthquakesUseCase.execute(query: query)
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
