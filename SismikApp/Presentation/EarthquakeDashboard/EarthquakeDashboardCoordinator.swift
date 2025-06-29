//
//  EarthquakeDashboardCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class EarthquakeDashboardCoordinator {
  weak var navigationController: UINavigationController?

  init(navigationController: UINavigationController? = nil) {
    self.navigationController = navigationController
  }

  func makeViewController() -> EarthquakeDashboardViewController {
    let service = USGSEarthquakeService()
    let repository = DefaultEarthquakeRepository(service: service)
    let useCase = DefaultFetchNearbyEarthquakesUseCase(repository: repository)
    let locationManager = DefaultLocationManager()
    let locationController = DefaultLocationStateController(locationManager: locationManager)

    let viewModel = EarthquakeDashboardViewModel(useCase: useCase, locationController: locationController)

    return EarthquakeDashboardViewController(viewModel: viewModel)
  }
}
