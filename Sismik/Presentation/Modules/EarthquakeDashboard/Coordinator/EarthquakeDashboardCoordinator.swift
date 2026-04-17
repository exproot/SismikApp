//
//  EarthquakeDashboardCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import CoreNetworking
import EarthquakeData
import EarthquakeDomain
import EarthquakeRemote
import LocationServices
import UIKit

final class EarthquakeDashboardCoordinator {
  weak var navigationController: UINavigationController?

  init(navigationController: UINavigationController? = nil) {
    self.navigationController = navigationController
  }

  func makeViewController() -> EarthquakeDashboardViewController {
    let httpClient = URLSessionHTTPClient()
    let usgsService = USGSEarthquakeService(client: httpClient)
    let emscService = EMSCEarthquakeService(client: httpClient)
    
    let usgsRemoteSource = USGSEarthquakeRemoteDataSource(service: usgsService)
    let emscRemoteSource = EMSCEarthquakeRemoteDataSource(service: emscService)
    let repository = DefaultEarthquakeRepository(remoteDataSource: usgsRemoteSource)
    
    let geocoder = DefaultGeocodingService()
    let enrichmentService = DefaultEarthquakeEnricher(geocoder: geocoder)
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
