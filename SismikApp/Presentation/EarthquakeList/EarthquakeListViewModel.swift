//
//  EarthquakeListViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine
import Foundation

enum EarthquakeListViewState {
  case loading
  case loaded([Earthquake])
  case empty
  case error(String)
}

protocol EarthquakeListViewModelDelegate: AnyObject {
  func showLocationPermissionScreen()
  func showDetail(for earthquake: Earthquake)
  func showMap(earthquakes: [Earthquake], radiusKm: Double, center: CLLocationCoordinate2D)
  func showFilterSheet(coordinate: CLLocationCoordinate2D, currentQuery: EarthquakeQuery)
}

final class DefaultEarthquakeListViewModel {

  @Published private(set) var state: EarthquakeListViewState = .loading

  private let fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol
  private let locationState: LocationStateControlling
  private let queryStore: EarthquakeQueryStoring
  private var cancellables = Set<AnyCancellable>()
  private weak var delegate: EarthquakeListViewModelDelegate?

  private(set) var lastCoordinate: CLLocationCoordinate2D?
  private var lastQuery: EarthquakeQuery?

  init(
    fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationState: LocationStateControlling,
    queryStore: EarthquakeQueryStoring,
    delegate: EarthquakeListViewModelDelegate
  ) {
    self.fetchNearbyEarthquakesUseCase = fetchNearbyEarthquakesUseCase
    self.locationState = locationState
    self.queryStore = queryStore
    self.delegate = delegate
  }

  func showFilter() {
    if let coordinate = lastCoordinate, let query = lastQuery {
      delegate?.showFilterSheet(coordinate: coordinate, currentQuery: query)
    }
  }

  func fetchFilteredEarthquakes(with query: EarthquakeQuery) {
    state = .loading
    lastQuery = query
    queryStore.save(query)

    fetchNearbyEarthquakesUseCase.execute(query: query)
      .sink { [weak self] completion in
        guard let self = self else { return }

        if case .failure = completion {
          self.state = .error(NSLocalizedString("earthquakes.error", comment: ""))
        }
      } receiveValue: { [weak self] earthquakes in
        if earthquakes.isEmpty {
          self?.state = .empty
        } else {
          self?.state = .loaded(earthquakes)
        }
      }
      .store(in: &cancellables)

  }

  func requestUserLocation() {
    locationState.authorizationStatusPublisher
      .sink { [weak self] status in
        if status == .denied {
          self?.delegate?.showLocationPermissionScreen()
        }
      }
      .store(in: &cancellables)

    locationState.coordinatePublisher
      .sink { [weak self] coordinate in
        let query = self?.queryStore.load() ?? EarthquakeQuery.defaultAround(coordinate)

        self?.fetchFilteredEarthquakes(with: query)
        self?.lastCoordinate = coordinate
      }
      .store(in: &cancellables)

    locationState.requestLocation()
  }

  func didSelectEarthquake(_ earthquake: Earthquake) {
    delegate?.showDetail(for: earthquake)
  }

  func didTapMap() {
    guard let coordinate = lastCoordinate,
          let searchRadiusKm = lastQuery?.radiusKm
    else { return }
    
    if case let .loaded(earthquakes) = state {
      delegate?.showMap(earthquakes: earthquakes, radiusKm: searchRadiusKm, center: coordinate)
    }
  }

  func reset() {
    cancellables.removeAll()
    state = .loading
    lastCoordinate = nil
    lastQuery = nil
  }
}
