//
//  EarthquakeDetailModule.swift
//  EarthquakeDetail
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import UIKit

@MainActor
public struct EarthquakeDetailModule {
  
  private let diContainer: EarthquakeDetailDIContainer
  
  public init(dependencies: EarthquakeDetailModuleDependencies) {
    self.diContainer = EarthquakeDetailDIContainer(dependencies: dependencies)
  }
  
  public func makeFlowCoordinator(navigationController: UINavigationController) -> EarthquakeDetailFlowCoordinator {
    diContainer.makeEarthquakeDetailFlowCoordinator(navigationController: navigationController)
  }
  
}
