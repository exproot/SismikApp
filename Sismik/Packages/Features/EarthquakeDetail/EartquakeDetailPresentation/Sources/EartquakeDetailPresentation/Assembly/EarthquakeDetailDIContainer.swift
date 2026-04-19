//
//  EarthquakeDetailDIContainer.swift
//  EarthquakeDetail
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

@MainActor
final class EarthquakeDetailDIContainer {
 
  private let dependencies: EarthquakeDetailModuleDependencies
  
  init(dependencies: EarthquakeDetailModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: View Models
  func makeEarthquakeDetailViewModel(actions: EarthquakeDetailViewModelActions) -> EarthquakeDetailViewModel {
    EarthquakeDetailViewModel(actions: actions, context: dependencies.context)
  }
  
  // MARK: Flow Coordinator
  func makeEarthquakeDetailFlowCoordinator(
    navigationController: UINavigationController
  ) -> EarthquakeDetailFlowCoordinator {
    EarthquakeDetailFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
  
}

// MARK: EarthquakeDetailFlowCoordinatorDependencies
extension EarthquakeDetailDIContainer: EarthquakeDetailFlowCoordinatorDependencies {
  
  func makeEarthquakeDetailViewController(actions: EarthquakeDetailViewModelActions) -> UIViewController {
    EarthquakeDetailViewController(viewModel: makeEarthquakeDetailViewModel(actions: actions))
  }

}
