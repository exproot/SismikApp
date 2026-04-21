//
//  MapDIContainer.swift
//  MapPresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

@MainActor
final class MapDIContainer {
  
  private let dependencies: MapModuleDependencies
  
  init(dependencies: MapModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: View Models
  func makeMapViewModel() -> EarthquakeMapViewModel {
    EarthquakeMapViewModel(context: dependencies.context)
  }
  
  // MARK: Flow Coordinator
  func makeMapFlowCoordinator(navigationController: UINavigationController) -> MapFlowCoordinator {
    MapFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
  
}

// MARK: MapFlowCoordinatorDependencies
extension MapDIContainer: MapFlowCoordinatorDependencies {
  func makeMapViewController() -> UIViewController {
    EarthquakeMapViewController(viewModel: makeMapViewModel())
  }
}
