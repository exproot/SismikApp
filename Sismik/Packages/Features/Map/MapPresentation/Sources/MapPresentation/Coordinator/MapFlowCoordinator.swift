//
//  MapFlowCoordinator.swift
//  MapPresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

@MainActor
protocol MapFlowCoordinatorDependencies {
  func makeMapViewController() -> UIViewController
}

@MainActor
public final class MapFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: MapFlowCoordinatorDependencies
  
  init(
    navigationController: UINavigationController,
    dependencies: MapFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public func start() {
    let viewController = dependencies.makeMapViewController()
    
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}
