//
//  EarthquakeDashboardViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

final class EarthquakeDashboardViewModel {

  @Published private(set) var snapshot: NSDiffableDataSourceSnapshot<EarthquakeDashboardSection, EarthquakeDashboardItem> = .init()

  private let useCase: FetchNearbyEarthquakesUseCaseProtocol
  private let locationController: LocationStateControlling
  private var cancellables = Set<AnyCancellable>()

  init(
    useCase: FetchNearbyEarthquakesUseCaseProtocol,
    locationController: LocationStateControlling
  ) {
    self.useCase = useCase
    self.locationController = locationController
  }

  func loadDashboard() {
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
        receiveCompletion: { _ in },
        receiveValue: { [weak self] quakes in
          self?.buildSnapshot(from: quakes)
        }
      )
      .store(in: &cancellables)
  }

  private func buildSnapshot(from earthquakes: [Earthquake]) {
    var snapshot = NSDiffableDataSourceSnapshot<EarthquakeDashboardSection, EarthquakeDashboardItem>()

    snapshot.appendSections([.summary])
    let summary = EarthquakeDashboardSummaryItem.make(from: earthquakes)
    snapshot.appendItems([.summary(summary)], toSection: .summary)

    snapshot.appendSections([.recent])
    let recent = earthquakes.sorted(by: { $0.time > $1.time }).prefix(10)
    snapshot.appendItems(recent.map { .recent($0) }, toSection: .recent)

    snapshot.appendSections([.biggest])
    if let biggest = earthquakes
      .max(by: { $0.magnitude < $1.magnitude }) {
      snapshot.appendItems([.biggest(biggest)], toSection: .biggest)
    }

    snapshot.appendSections([.tip])
    snapshot.appendItems([.tip(EarthquakeTips.randomTip())], toSection: .tip)

    self.snapshot = snapshot
  }

}
