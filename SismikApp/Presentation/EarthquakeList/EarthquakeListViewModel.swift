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
  func fetchFilteredEarthquakes(with query: EarthquakeQuery)
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

  private(set) var lastCoordinate: CLLocationCoordinate2D?
  private var lastQuery: EarthquakeQuery?

  var showLocationDeniedScreen: (() -> Void)?
  var showEarthquakeDetails: ((Earthquake) -> Void)?
  var showEarthquakeMap: (([Earthquake], Double, CLLocationCoordinate2D) -> Void)?
  var showFilterSheet: ((CLLocationCoordinate2D, EarthquakeQuery) -> Void)?

  var filterSummaryText: String? {
    guard let query = lastQuery else { return nil }

    let magText = "Magnitude \(String(format: "%.1f", query.minMagnitude ?? 0.0)) – \(String(format: "%.1f", query.maxMagnitude ?? 10.0))"

    let formatter = DateFormatter()
    formatter.dateStyle = .medium

    if let start = query.startTime, let end = query.endTime {
      return "\(magText), \(formatter.string(from: start)) – \(formatter.string(from: end))"
    } else {
      return "\(magText)"
    }
  }

  init(
    fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationManager: LocationManagerProtocol,
    showLocationDeniedScreen: @escaping () -> Void,
    showEarthquakeDetails: @escaping (Earthquake) -> Void,
    showEarthquakeMap: @escaping ([Earthquake], Double, CLLocationCoordinate2D) -> Void,
    showFilterSheet: @escaping (CLLocationCoordinate2D, EarthquakeQuery) -> Void)
  {
    self.fetchNearbyEarthquakesUseCase = fetchNearbyEarthquakesUseCase
    self.locationManager = locationManager
    self.showLocationDeniedScreen = showLocationDeniedScreen
    self.showEarthquakeDetails = showEarthquakeDetails
    self.showEarthquakeMap = showEarthquakeMap
    self.showFilterSheet = showFilterSheet
  }

  var searchRadiusKm: Double {
    if let query = lastQuery,
       let radiusKm = query.radiusKm
    {
      return radiusKm
    }

    return 222.0
  }

  func showFilter() {
    if let coordinate = lastCoordinate,
       let query = lastQuery
    {
      showFilterSheet?(coordinate, query)
    }
  }

  func fetchFilteredEarthquakes(with query: EarthquakeQuery) {
    isLoading = true
    errorMessage = nil
    lastQuery = query
    query.saveToDefaults()

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
        let query = EarthquakeQuery.loadFromDefaults() ?? EarthquakeQuery.defaultAround(coordinate)
        self?.fetchFilteredEarthquakes(with: query)
        self?.lastCoordinate = coordinate
      }
      .store(in: &cancellables)

    locationManager.requestLocation()
  }
}
