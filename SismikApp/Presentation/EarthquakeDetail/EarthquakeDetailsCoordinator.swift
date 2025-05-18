//
//  EarthquakeDetailCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import SwiftUI

final class EarthquakeDetailCoordinator {

  weak var navigationController: UINavigationController?
  private let earthquake: Earthquake

  init(navigationController: UINavigationController?, earthquake: Earthquake) {
    self.navigationController = navigationController
    self.earthquake = earthquake
  }

  func makeViewController() -> UIViewController {
    let viewModel = EarthquakeDetailViewModel(earthquake: earthquake, showEarthquakeMap: showEarthquakeMap)
    let detailView = EarthquakeDetailView(viewModel: viewModel)
    let hostingVC = UIHostingController(rootView: detailView)
    return hostingVC
  }

  private func showEarthquakeMap(_ earthquakes: [Earthquake], searchRadiusKm: Double, centerCoordinate: CLLocationCoordinate2D) {
    let earthquakeMapCoordinator = EarthquakeMapCoordinator(
      navigationController: navigationController,
      searchRadiusKm: searchRadiusKm,
      centerCoordinate: centerCoordinate
    )
    let earthquakeMapController = earthquakeMapCoordinator.makeViewController(earthquakes: earthquakes)

    navigationController?.pushViewController(earthquakeMapController, animated: true)
  }

}
