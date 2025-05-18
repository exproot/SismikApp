//
//  EarthquakeMapCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import UIKit

final class EarthquakeMapCoordinator {

  weak var navigationController: UINavigationController?

  private let searchRadiusKm: Double

  init(navigationController: UINavigationController? = nil, searchRadiusKm: Double) {
    self.navigationController = navigationController
    self.searchRadiusKm = searchRadiusKm
  }

  func makeViewController(earthquakes: [Earthquake]) -> UIViewController {
    let mapRegionProvider = MapRegionProvider()
    let viewModel = EarthquakeMapViewModel(earthquakes: earthquakes, mapRegionProvider: mapRegionProvider, searchRadiusKm: searchRadiusKm)
    let mapVC = EarthquakeMapViewController(viewModel: viewModel)

    return mapVC
  }

}
