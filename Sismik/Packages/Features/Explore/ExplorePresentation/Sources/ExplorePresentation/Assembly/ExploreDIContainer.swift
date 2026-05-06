//
//  ExploreDIContainer.swift
//  ExplorePresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import EarthquakeDomain
import EarthquakeSupport
import LocationServices
import UIKit

@MainActor
final class ExploreDIContainer {
  
  private let dependencies: ExploreModuleDependencies
  
  init(dependencies: ExploreModuleDependencies) {
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
  func makeExploreViewModel(actions: ExploreViewModelActions) -> EarthquakeExploreViewModel {
    EarthquakeExploreViewModel(
      actions: actions,
      fetchNearbyEarthquakesUseCase: makeFetchNearbyEarthquakesUseCase(),
      geocoder: dependencies.geocoder,
      queryStore: dependencies.queryStore
    )
  }
  
  // MARK: Flow Coordinator
  func makeExploreFlowCoordinator(navigationController: UINavigationController) -> ExploreFlowCoordinator {
    ExploreFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
  
}

// MARK: ExploreFlowCoordinatorDependencies
extension ExploreDIContainer: ExploreFlowCoordinatorDependencies {
  
  func makeExploreScene(actions: ExploreViewModelActions) -> ExploreScene {
    let viewModel = makeExploreViewModel(actions: actions)
    let viewController = EarthquakeExploreViewController(viewModel: viewModel)
    
    return ExploreScene(viewController: viewController, filterApplying: viewModel)
  }
  
}
