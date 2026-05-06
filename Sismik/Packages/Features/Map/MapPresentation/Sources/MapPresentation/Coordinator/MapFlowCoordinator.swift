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

public protocol MapFlowCoordinatorDelegate: AnyObject {
  func mapFlowCoordinatorDidFinish(_ coordinator: MapFlowCoordinator)
}

@MainActor
public final class MapFlowCoordinator {
  
  public weak var delegate: MapFlowCoordinatorDelegate?
  
  private weak var navigationController: UINavigationController?
  private weak var rootViewController: UIViewController?
  private let dependencies: MapFlowCoordinatorDependencies
  
  init(
    navigationController: UINavigationController,
    dependencies: MapFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public var rootNavigationController: UINavigationController? {
    navigationController
  }
  
  public var trackedRootViewController: UIViewController? {
    rootViewController
  }
  
  public func start() {
    let viewController = dependencies.makeMapViewController()
    rootViewController = viewController
    
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}
