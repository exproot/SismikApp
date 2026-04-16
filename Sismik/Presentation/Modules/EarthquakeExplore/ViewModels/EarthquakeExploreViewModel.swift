//
//  EarthquakeExploreViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import Combine
import Foundation

protocol EarthquakeExploreViewModelDelegate: AnyObject {
  func showDetail(for earthquake: Earthquake)
  func showMap(earthquakes: [Earthquake], radiusKm: Double, center: CLLocationCoordinate2D)
  func showFilterSheet(options: EarthquakeFilterOptions)
}

final class EarthquakeExploreViewModel {

  @Published private(set) var state: EarthquakeExploreViewState = .empty
  @Published private(set) var viewMode: ExploreViewMode = .list

  var currentFilterOptions: EarthquakeFilterOptions = .default

  private let fetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol
  private let geocoder: GeocodingServiceProtocol
  private let queryStore: EarthquakeQueryStoring
  private weak var delegate: EarthquakeExploreViewModelDelegate?
  private var cancellables = Set<AnyCancellable>()

  private(set) var lastCoordinate: CLLocationCoordinate2D?

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

  func buildQuery(with coordinate: CLLocationCoordinate2D) -> EarthquakeQuery {
    EarthquakeQuery(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
      radiusKm: currentFilterOptions.radiusKm,
      minMagnitude: currentFilterOptions.minMagnitude,
      maxMagnitude: currentFilterOptions.maxMagnitude,
      startTime: currentFilterOptions.startDate,
      endTime: currentFilterOptions.endDate
    )
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
        guard let self = self else { return }
        self.lastCoordinate = coordinate

        let query = self.buildQuery(with: coordinate)

        self.fetchFilteredEarthquakes(with: query)
      }
      .store(in: &cancellables)
  }

  func updateViewMode(_ mode: ExploreViewMode) {
    viewMode = mode

    if mode == .map {
      didTapMap()
    }
  }

  func updateFilter(_ options: EarthquakeFilterOptions) {
    currentFilterOptions = options
  }

  func showFilter() {
    delegate?.showFilterSheet(options: currentFilterOptions)
  }

  func fetchFilteredEarthquakes(with query: EarthquakeQuery) {
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
    guard let coordinate = lastCoordinate else { return }

    let radiusKm = currentFilterOptions.radiusKm

    if case let .loaded(cellModels) = state {
      delegate?.showMap(
        earthquakes: cellModels.map { $0.earthquake },
        radiusKm: radiusKm,
        center: coordinate
      )
    }
  }

  func reset() {
    cancellables.removeAll()
    state = .loading
    lastCoordinate = nil
  }

}
