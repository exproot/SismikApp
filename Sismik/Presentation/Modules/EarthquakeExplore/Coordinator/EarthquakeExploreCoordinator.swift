//
//  EarthquakeExploreCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import CoreLocation
import CoreNetworking
import EarthquakeDomain
import EarthquakeRemote
import LocationServices
import UIKit

final class EarthquakeExploreCoordinator {

  weak var navigationController: UINavigationController?
  private var activeFilterCoordinator: EarthquakeFilterCoordinator?
  private var viewModel: EarthquakeExploreViewModel?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let geocoder = DefaultGeocodingService()
    let enrichmentService = DefaultEarthquakeEnricher(geocoder: geocoder)
    let queryStore = DefaultEarthquakeQueryStore()
    
    let httpClient = URLSessionHTTPClient()
    let usgsService = USGSEarthquakeService(client: httpClient)
    let emscService = EMSCEarthquakeService(client: httpClient)
    
    let usgsRemoteSource = USGSEarthquakeRemoteDataSource(service: usgsService)
    let emscRemoteSource = EMSCEarthquakeRemoteDataSource(service: emscService)
    let earthquakeRepository = DefaultEarthquakeRepository(remoteDataSource: usgsRemoteSource)
    
    let fetchNearbyEarthquakesUseCase = DefaultFetchNearbyEarthquakesUseCase(repository: earthquakeRepository, enrichmentService: enrichmentService)

    let earthquakeExploreViewModel = EarthquakeExploreViewModel(
      fetchNearbyEarthquakesUseCase: fetchNearbyEarthquakesUseCase,
      geocoder: geocoder,
      queryStore: queryStore,
      delegate: self
    )

    self.viewModel = earthquakeExploreViewModel

    let listVC = EarthquakeExploreViewController(viewModel: earthquakeExploreViewModel)
    return listVC
  }

}

// MARK: EarthquakeListViewModelDelegate
extension EarthquakeExploreCoordinator: EarthquakeExploreViewModelDelegate {
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

    earthquakeMapController.hidesBottomBarWhenPushed = true

    navigationController?.pushViewController(earthquakeMapController, animated: true)
  }

  func showFilterSheet(options: EarthquakeFilterOptions) {
    let filterCoordinator = EarthquakeFilterCoordinator(
      navigationController: navigationController,
      initialOptions: options
    )

    activeFilterCoordinator = filterCoordinator

    let filterVC = filterCoordinator.makeViewController { [weak self] options in
      self?.viewModel?.updateFilter(options)
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
