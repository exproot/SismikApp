//
//  OnboardingDIContainer.swift
//  OnboardingPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import UIKit

@MainActor
final class OnboardingDIContainer {
  
  // MARK: View Models
  func makeOnboardingViewModel(actions: OnboardingViewModelActions) -> OnboardingViewModel {
    OnboardingViewModel(actions: actions)
  }
  
  // MARK: Flow Coordinator
  func makeOnboardingFlowCoordinator(
    navigationController: UINavigationController
  ) -> OnboardingFlowCoordinator {
    OnboardingFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
  
}

// MARK: OnboardingFlowCoordinatorDependencies
extension OnboardingDIContainer: OnboardingFlowCoordinatorDependencies {
  func makeOnboardingViewController(actions: OnboardingViewModelActions) -> UIViewController {
    OnboardingViewController(viewModel: makeOnboardingViewModel(actions: actions))
  }
}
