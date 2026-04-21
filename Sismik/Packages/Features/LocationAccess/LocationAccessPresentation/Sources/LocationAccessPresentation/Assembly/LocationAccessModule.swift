//
//  LocationAccessModule.swift
//  LocationAccessPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import UIKit

@MainActor
public struct LocationAccessModule {
  
  private let diContainer: LocationAccessDIContainer
  
  public init() {
    self.diContainer = LocationAccessDIContainer()
  }
  
  public func makeFlowCoordinator(
    navigationController: UINavigationController
  ) -> LocationAccessFlowCoordinator {
    diContainer.makeLocationAccessFlowCoordinator(navigationController: navigationController)
  }
  
}
