//
//  EarthquakeExploreViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine
import Foundation

enum EarthquakeExploreViewState {
  case loading
  case loaded([Earthquake])
  case empty
  case error(String)
}

protocol EarthquakeExploreViewModelDelegate: AnyObject {
  func showDetail(for earthquake: Earthquake)
  func showMap(earthquakes: [Earthquake], radiusKm: Double, center: CLLocationCoordinate2D)
  func showFilterSheet(coordinate: CLLocationCoordinate2D, currentQuery: EarthquakeQuery)
}

final class EarthquakeExploreViewModel {

  @Published private(set) var state: EarthquakeExploreViewState = .empty

  private let fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol
  private let geocoder: GeocodingServiceProtocol
  private let queryStore: EarthquakeQueryStoring
  private var cancellables = Set<AnyCancellable>()
  private weak var delegate: EarthquakeExploreViewModelDelegate?

  private(set) var lastCoordinate: CLLocationCoordinate2D?
  private(set) var lastQuery: EarthquakeQuery?

  init(
    fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol,
    geocoder: GeocodingServiceProtocol,
    queryStore: EarthquakeQueryStoring,
    delegate: EarthquakeExploreViewModelDelegate
  ) {
    self.fetchNearbyEarthquakesUseCase = fetchNearbyEarthquakesUseCase
    self.geocoder = geocoder
    self.queryStore = queryStore
    self.delegate = delegate
  }

  func search(for placeName: String) {
    guard !placeName.isEmpty else { return }

    state = .loading

    geocoder.geocode(placeName)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.state = .error(NSLocalizedString("explore.geocoding.error", comment: ""))
        }
      } receiveValue: { [weak self] coordinate in
        self?.lastCoordinate = coordinate
        let query = EarthquakeQuery.defaultAround(coordinate)
        self?.fetchFilteredEarthquakes(with: query)
      }
      .store(in: &cancellables)
  }

  func showFilter() {
    if let coordinate = lastCoordinate, let query = lastQuery {
      delegate?.showFilterSheet(coordinate: coordinate, currentQuery: query)
    }
  }

  func fetchFilteredEarthquakes(with query: EarthquakeQuery) {
    lastQuery = query
    queryStore.save(query)

    fetchNearbyEarthquakesUseCase.execute(query: query)
      .sink { [weak self] completion in
        guard let self = self else { return }

        if case .failure = completion {
          self.state = .error(NSLocalizedString("explore.error", comment: ""))
        }
      } receiveValue: { [weak self] earthquakes in
        self?.state = earthquakes.isEmpty ? .empty : .loaded(earthquakes)
      }
      .store(in: &cancellables)

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
