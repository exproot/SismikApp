//
//  EarthquakeDashboardViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

enum EarthquakeDashboardState {
  case loading
  case loaded(NSDiffableDataSourceSnapshot<EarthquakeDashboardSection, EarthquakeDashboardItem>)
  case error(String)
}

final class EarthquakeDashboardViewModel {

  @Published private(set) var state: EarthquakeDashboardState = .loading

  private let useCase: FetchNearbyEarthquakesUseCaseProtocol
  private let locationController: LocationStateControlling
  private var cancellables = Set<AnyCancellable>()

  var showLocationDeniedScreen: (() -> Void)?

  init(
    useCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationController: LocationStateControlling,
    showLocationDeniedScreen: @escaping () -> Void
  ) {
    self.useCase = useCase
    self.locationController = locationController
    self.showLocationDeniedScreen = showLocationDeniedScreen
  }

  func fetchLocationPermission() {
    locationController.authorizationStatusPublisher
      .sink { [weak self] status in
        switch status {
        case .authorized:
          self?.loadDashboard()
        case .denied:
          self?.showLocationDeniedScreen?()
        case .notDetermined:
          self?.locationController.requestLocation()
        }
      }
      .store(in: &cancellables)
  }

  func loadDashboard() {
    state = .loading
    locationController.coordinatePublisher
      .prefix(1)
      .sink { [weak self] coordinate in
        guard let self = self else { return }
        let query = EarthquakeQuery.defaultAround(coordinate)
        self.fetchEarthquakes(query: query)
      }
      .store(in: &cancellables)

    locationController.requestLocation()
  }

  private func fetchEarthquakes(query: EarthquakeQuery) {
    useCase.execute(query: query)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure = completion {
            self?.state = .error(NSLocalizedString("dashboard.error", comment: ""))
          }
        },
        receiveValue: { [weak self] quakes in
          guard let self = self else { return }
          let snapshot = self.buildSnapshot(from: quakes)
          self.state = .loaded(snapshot)
        }
      )
      .store(in: &cancellables)
  }

  private func buildSnapshot(from earthquakes: [EnrichedEarthquake]) -> NSDiffableDataSourceSnapshot<EarthquakeDashboardSection, EarthquakeDashboardItem> {
    let earthquakes = earthquakes.map { $0.earthquake }
    var snapshot = NSDiffableDataSourceSnapshot<EarthquakeDashboardSection, EarthquakeDashboardItem>()

    snapshot.appendSections([.summary])
    let summary = EarthquakeDashboardSummaryItem.make(from: earthquakes)
    snapshot.appendItems([.summary(summary)], toSection: .summary)

    if earthquakes.isEmpty {
      snapshot.appendSections([.recent])
      snapshot.appendItems([.recentPlaceholder(NSLocalizedString("dashboard.section.recent.empty", comment: ""))], toSection: .recent)

      snapshot.appendSections([.biggest])
      snapshot.appendItems([.biggestPlaceholder(NSLocalizedString("dashboard.section.biggest.empty", comment: ""))])
    } else {
      snapshot.appendSections([.recent])
      let recent = earthquakes.sorted(by: { $0.time > $1.time }).prefix(10)

      if recent.isEmpty {
        snapshot.appendItems([.recentPlaceholder(NSLocalizedString("dashboard.section.recent.empty", comment: ""))], toSection: .recent)
      } else {
        snapshot.appendItems(recent.map { .recent($0) }, toSection: .recent)
      }

      snapshot.appendSections([.biggest])
      if let biggest = earthquakes.max(by: { $0.magnitude < $1.magnitude }) {
        snapshot.appendItems([.biggest(biggest)], toSection: .biggest)
      } else {
        snapshot.appendItems([.biggestPlaceholder(NSLocalizedString("dashboard.section.biggest.empty", comment: ""))])
      }
    }

    snapshot.appendSections([.tip])
    snapshot.appendItems([.tip(EarthquakeTips.randomTip())], toSection: .tip)

    return snapshot
  }

}
