//
//  ExploreModule.swift
//  ExplorePresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

struct ExploreScene {
  let viewController: UIViewController
  let filterApplying: ExploreFilterApplying
}

@MainActor
public struct ExploreModule {
  
  private let diContainer: ExploreDIContainer
  
  public init(dependencies: ExploreModuleDependencies) {
    self.diContainer = ExploreDIContainer(dependencies: dependencies)
  }
  
  public func makeFlowCoordinator(navigationController: UINavigationController) -> ExploreFlowCoordinator {
    diContainer.makeExploreFlowCoordinator(navigationController: navigationController)
  }
  
}
