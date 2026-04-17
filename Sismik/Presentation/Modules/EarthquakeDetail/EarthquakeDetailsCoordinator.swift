//
//  EarthquakeDetailCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import EarthquakeDomain
import CoreLocation
import UIKit

final class EarthquakeDetailCoordinator {

  weak var navigationController: UINavigationController?
  private let earthquake: Earthquake

  init(navigationController: UINavigationController?, earthquake: Earthquake) {
    self.navigationController = navigationController
    self.earthquake = earthquake
  }

  func makeViewController() -> EarthquakeDetailViewController {
    let queryStore = DefaultEarthquakeQueryStore()

    let viewModel = EarthquakeDetailViewModel(
      earthquake: earthquake,
      queryStore: queryStore,
      showEarthquakeMap: showEarthquakeMap
    )

    return EarthquakeDetailViewController(viewModel: viewModel)
  }

  private func showEarthquakeMap(_ earthquakes: [Earthquake], searchRadiusKm: Double, centerCoordinate: CLLocationCoordinate2D) {
    let earthquakeMapCoordinator = EarthquakeMapCoordinator(
      navigationController: navigationController,
      searchRadiusKm: searchRadiusKm,
      centerCoordinate: centerCoordinate
    )

    let mapVC = earthquakeMapCoordinator.makeViewController(earthquakes: earthquakes)
    navigationController?.pushViewController(mapVC, animated: true)
  }

}
