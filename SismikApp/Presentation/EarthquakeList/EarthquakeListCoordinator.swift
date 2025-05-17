//
//  EarthquakeListCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import SwiftUI

final class EarthquakeListCoordinator {

  weak var navigationController: UINavigationController?
  private var activeFilterCoordinator: EarthquakeFilterCoordinator?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let earthquakeService = USGSEarthquakeService()
    let locationManager = DefaultLocationManager()
    let earthquakeRepository = DefaultEarthquakeRepository(service: earthquakeService)
    let fetchNearbyEarthquakesUseCase = DefaultFetchNearbyEarthquakesUseCase(repository: earthquakeRepository)
    let earthquakeListViewModel = DefaultEarthquakeListViewModel(
      fetchNearbyEarthquakesUseCase: fetchNearbyEarthquakesUseCase,
      locationManager: locationManager,
      showLocationDeniedScreen: showLocationDeniedScreen,
      showEarthquakeDetails: showEarthquakeDetails,
      showEarthquakeMap: showEarthquakeMap,
      showFilterSheet: showFilterSheet
    )
    let view = EarthquakeListView(viewModel: earthquakeListViewModel)
    let hostingVC = UIHostingController(rootView: view)

    return hostingVC
  }

  private func showLocationDeniedScreen() {
    let locationAccessVC = LocationAccessCoordinator(navigationController: navigationController).makeViewController()

    navigationController?.present(locationAccessVC, animated: true)
  }

  private func showEarthquakeDetails(_ earthquake: Earthquake) {
    let earthquakeDetailsCoordinator = EarthquakeDetailCoordinator(navigationController: navigationController, earthquake: earthquake)
    let earthquakeDetailsController = earthquakeDetailsCoordinator.makeViewController()

    navigationController?.pushViewController(earthquakeDetailsController, animated: true)
  }

  private func showEarthquakeMap(_ earthquakes: [Earthquake]) {
    let earthquakeMapCoordinator = EarthquakeMapCoordinator(navigationController: navigationController)
    let earthquakeMapController = earthquakeMapCoordinator.makeViewController(earthquakes: earthquakes)

    navigationController?.pushViewController(earthquakeMapController, animated: true)
  }

  private func showFilterSheet(coordinate: CLLocationCoordinate2D, currentQuery: EarthquakeQuery) {
    let filterCoordinator = EarthquakeFilterCoordinator(
      navigationController: navigationController,
      coordinate: coordinate,
      initialQuery: currentQuery
    )

    activeFilterCoordinator = filterCoordinator

    let filterVC = filterCoordinator.makeViewController { [weak self] query in
      if let hostingVC = self?.navigationController?.topViewController as? UIHostingController<EarthquakeListView> {
        hostingVC.rootView.viewModel.fetchFilteredEarthquakes(with: query)
      }
    }

    filterCoordinator.onCleanup = { [weak self] in
      self?.activeFilterCoordinator = nil
    }

    filterVC.modalPresentationStyle = .pageSheet

    if let sheet = filterVC.sheetPresentationController {
      sheet.detents = [.large()]
      sheet.prefersGrabberVisible = true
    }

    navigationController?.present(filterVC, animated: true)
  }

}
