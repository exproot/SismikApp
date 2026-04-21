//
//  LocationAccessDIContainer.swift
//  LocationAccessPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import SwiftUI

@MainActor
final class LocationAccessDIContainer {
  
  // MARK: View Models
  func makeLocationAccessViewModel(
    actions: LocationAccessViewModelActions
  ) -> LocationAccessViewModel {
    LocationAccessViewModel(actions: actions)
  }
  
  // MARK: Flow Coordinator
  func makeLocationAccessFlowCoordinator(
    navigationController: UINavigationController
  ) -> LocationAccessFlowCoordinator {
    LocationAccessFlowCoordinator(navigationController: navigationController, dependencies: self)
  }
  
}


// MARK: LocationAccessFlowCoordinatorDependencies
extension LocationAccessDIContainer: LocationAccessFlowCoordinatorDependencies {
  
  func makeLocationAccessHostingController(actions: LocationAccessViewModelActions) -> UIViewController {
    UIHostingController(
      rootView: LocationAccessView(viewModel: makeLocationAccessViewModel(actions: actions))
    )
  }
  
}
