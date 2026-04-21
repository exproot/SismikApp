//
//  MapModule.swift
//  MapPresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

@MainActor
public struct MapModule {
  
  private let diContainer: MapDIContainer
  
  public init(dependencies: MapModuleDependencies) {
    self.diContainer = MapDIContainer(dependencies: dependencies)
  }
  
  public func makeFlowCoordinator(navigationController: UINavigationController) -> MapFlowCoordinator {
    diContainer.makeMapFlowCoordinator(navigationController: navigationController)
  }
  
}
