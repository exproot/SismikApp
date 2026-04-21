//
//  DashboardDIContainer.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import EarthquakeDomain
import LocationServices
import UIKit

@MainActor
final class DashboardDIContainer {
  
  private let dependencies: DashboardModuleDependencies
  
  init(dependencies: DashboardModuleDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: Use Cases
  func makeFetchNearbyEarthquakesUseCase() -> FetchNearbyEarthquakesUseCaseProtocol {
    DefaultFetchNearbyEarthquakesUseCase(
      repository: dependencies.earthquakeRepository,
      enricher: dependencies.enricher
    )
  }
  
  // MARK: View Models
  func makeDashboardViewModel(
    actions: DashboardViewModelActions
  ) -> EarthquakeDashboardViewModel {
    EarthquakeDashboardViewModel(
      actions: actions,
      useCase: makeFetchNearbyEarthquakesUseCase(),
      locationController: dependencies.makeLocationStateController()
    )
  }
  
  // MARK: Flow Coordinator
  func makeDashboardCoordinator(
    navigationController: UINavigationController
  ) -> DashboardFlowCoordinator {
    DashboardFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
  
}

// MARK: DashboardFlowCoordinatorDependencies
extension DashboardDIContainer: DashboardFlowCoordinatorDependencies {
  func makeDashboardViewController(
    actions: DashboardViewModelActions
  ) -> UIViewController {
    EarthquakeDashboardViewController(viewModel: makeDashboardViewModel(actions: actions))
  }
}
