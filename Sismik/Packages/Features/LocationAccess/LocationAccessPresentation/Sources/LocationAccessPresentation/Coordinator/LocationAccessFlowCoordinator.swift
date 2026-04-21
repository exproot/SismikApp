//
//  LocationAccessFlowCoordinator.swift
//  LocationAccessPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import SwiftUI

@MainActor
protocol LocationAccessFlowCoordinatorDependencies {
  func makeLocationAccessHostingController(
    actions: LocationAccessViewModelActions
  ) -> UIViewController
}

public protocol LocationAccessFlowCoordinatorDelegate: AnyObject {
  func didRequestOpenAppSettings(_ coordinator: LocationAccessFlowCoordinator)
}

@MainActor
public final class LocationAccessFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: LocationAccessFlowCoordinatorDependencies
  
  public weak var delegate: LocationAccessFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: LocationAccessFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public func start() {
    let actions = LocationAccessViewModelActions { [weak self] in
      guard let self else { return }
      
      self.delegate?.didRequestOpenAppSettings(self)
    }
    
    let viewController = dependencies.makeLocationAccessHostingController(actions: actions)
    
    navigationController?.present(viewController, animated: true)
  }
  
}
