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
    let geocoder = DefaultGeocodingService()
    let enrichmentService = EarthquakeEnrichmentService(geocoder: geocoder)
    let useCase = DefaultFetchNearbyEarthquakesUseCase(repository: repository, enrichmentService: enrichmentService)
    let locationManager = DefaultLocationManager()
    let locationController = DefaultLocationStateController(locationManager: locationManager)

    let viewModel = EarthquakeDashboardViewModel(
      delegate: self,
      useCase: useCase,
      locationController: locationController,
      showLocationDeniedScreen: presentLocationDeniedScreen
    )

    return EarthquakeDashboardViewController(viewModel: viewModel)
  }


  private func presentLocationDeniedScreen() {
    let locationAccessVC = LocationAccessCoordinator(navigationController: navigationController).makeViewController()

    navigationController?.present(locationAccessVC, animated: true)
  }
}

// MARK: EarthquakeDashboardViewModelDelegate
extension EarthquakeDashboardCoordinator: EarthquakeDashboardViewModelDelegate {
  func showDetail(for earthquake: Earthquake) {
    let earthquakeDetailsCoordinator = EarthquakeDetailCoordinator(navigationController: navigationController, earthquake: earthquake)
    let earthquakeDetailsController = earthquakeDetailsCoordinator.makeViewController()

    navigationController?.pushViewController(earthquakeDetailsController, animated: true)
  }
}
