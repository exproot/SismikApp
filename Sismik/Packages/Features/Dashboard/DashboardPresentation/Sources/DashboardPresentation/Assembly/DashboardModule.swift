//
//  DashboardModule.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 18.04.2026.
//

import EarthquakeDomain
import LocationServices
import UIKit

@MainActor
public final class DashboardModule {
  
  private let diContainer: DashboardDIContainer
  
  public init(dependencies: DashboardModuleDependencies) {
    self.diContainer = DashboardDIContainer(dependencies: dependencies)
  }
  
  public func makeFlowCoordinator(
    navigationController: UINavigationController
  ) -> DashboardFlowCoordinator {
    diContainer.makeDashboardCoordinator(navigationController: navigationController)
  }
  
}
