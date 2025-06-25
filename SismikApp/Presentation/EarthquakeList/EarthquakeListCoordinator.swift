//
//  EarthquakeListCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import UIKit
import CoreLocation

final class EarthquakeListCoordinator {

  weak var navigationController: UINavigationController?
  private var activeFilterCoordinator: EarthquakeFilterCoordinator?
  private var viewModel: DefaultEarthquakeListViewModel?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let earthquakeService = USGSEarthquakeService()
    let locationManager = DefaultLocationManager()
    let locationStateController = DefaultLocationStateController(locationManager: locationManager)
    let queryStore = DefaultEarthquakeQueryStore()
    let earthquakeRepository = DefaultEarthquakeRepository(service: earthquakeService)
    let fetchNearbyEarthquakesUseCase = DefaultFetchNearbyEarthquakesUseCase(repository: earthquakeRepository)

    let earthquakeListViewModel = DefaultEarthquakeListViewModel(
      fetchNearbyEarthquakesUseCase: fetchNearbyEarthquakesUseCase,
      locationState: locationStateController,
      queryStore: queryStore,
      delegate: self
    )

    self.viewModel = earthquakeListViewModel

    let listVC = EarthquakeListViewController(viewModel: earthquakeListViewModel)
    return listVC
  }

}

// MARK: EarthquakeListViewModelDelegate
extension EarthquakeListCoordinator: EarthquakeListViewModelDelegate {
  func showLocationPermissionScreen() {
    let locationAccessVC = LocationAccessCoordinator(navigationController: navigationController).makeViewController()

    navigationController?.present(locationAccessVC, animated: true)
  }
  
  func showDetail(for earthquake: Earthquake) {
    let earthquakeDetailsCoordinator = EarthquakeDetailCoordinator(navigationController: navigationController, earthquake: earthquake)
    let earthquakeDetailsController = earthquakeDetailsCoordinator.makeViewController()

    navigationController?.pushViewController(earthquakeDetailsController, animated: true)
  }
  
  func showMap(earthquakes: [Earthquake], radiusKm: Double, center: CLLocationCoordinate2D) {
    let earthquakeMapCoordinator = EarthquakeMapCoordinator(
      navigationController: navigationController,
      searchRadiusKm: radiusKm,
      centerCoordinate: center
    )

    let earthquakeMapController = earthquakeMapCoordinator.makeViewController(earthquakes: earthquakes)

    navigationController?.pushViewController(earthquakeMapController, animated: true)
  }

  func showFilterSheet(coordinate: CLLocationCoordinate2D, currentQuery: EarthquakeQuery) {
    let filterCoordinator = EarthquakeFilterCoordinator(
      navigationController: navigationController,
      coordinate: coordinate,
      initialQuery: currentQuery
    )

    activeFilterCoordinator = filterCoordinator

    let filterVC = filterCoordinator.makeViewController { [weak self] query in
      self?.viewModel?.fetchFilteredEarthquakes(with: query)
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
