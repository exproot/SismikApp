//
//  EarthquakeMapCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import EarthquakeDomain
import CoreLocation
import UIKit

final class EarthquakeMapCoordinator {

  weak var navigationController: UINavigationController?

  private let searchRadiusKm: Double
  private let centerCoordinate: CLLocationCoordinate2D

  init(
    navigationController: UINavigationController? = nil,
    searchRadiusKm: Double,
    centerCoordinate: CLLocationCoordinate2D
  ) {
    self.navigationController = navigationController
    self.searchRadiusKm = searchRadiusKm
    self.centerCoordinate = centerCoordinate
  }

  func makeViewController(earthquakes: [Earthquake]) -> UIViewController {
    let mapRegionProvider = EarthquakeMapRegionProvider()
    let viewModel = EarthquakeMapViewModel(
      earthquakes: earthquakes,
      mapRegionProvider: mapRegionProvider,
      searchRadiusKm: searchRadiusKm,
      centerCoordinate: centerCoordinate
    )
    let mapVC = EarthquakeMapViewController(viewModel: viewModel)

    return mapVC
  }

}
