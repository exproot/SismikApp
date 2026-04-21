//
//  OnboardingModule.swift
//  OnboardingPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import UIKit

@MainActor
public struct OnboardingModule {
  
  private let diContainer: OnboardingDIContainer
  
  public init() {
    self.diContainer = OnboardingDIContainer()
  }
  
  public func makeFlowCoordinator(
    navigationController: UINavigationController
  ) -> OnboardingFlowCoordinator {
    diContainer.makeOnboardingFlowCoordinator(navigationController: navigationController)
  }
  
}
