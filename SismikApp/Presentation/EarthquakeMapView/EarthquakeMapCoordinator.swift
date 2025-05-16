//
//  EarthquakeMapCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import UIKit

final class EarthquakeMapCoordinator {

  weak var navigationController: UINavigationController?

  init(navigationController: UINavigationController? = nil) {
    self.navigationController = navigationController
  }

  func makeViewController(earthquakes: [Earthquake]) -> UIViewController {
    let mapRegionProvider = MapRegionProvider()
    let viewModel = EarthquakeMapViewModel(earthquakes: earthquakes, mapRegionProvider: mapRegionProvider)
//    let view = EarthquakeMapView(viewModel: viewModel)
//    let hostingVC = UIHostingController(rootView: view)
    let mapVC = EarthquakeMapViewController(viewModel: viewModel)

    return mapVC
  }

}
