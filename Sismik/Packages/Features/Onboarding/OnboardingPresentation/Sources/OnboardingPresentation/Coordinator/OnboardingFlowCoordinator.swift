//
//  OnboardingFlowCoordinator.swift
//  OnboardingPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import UIKit

@MainActor
protocol OnboardingFlowCoordinatorDependencies {
  func makeOnboardingViewController(actions: OnboardingViewModelActions) -> UIViewController
}

public protocol OnboardingFlowCoordinatorDelegate: AnyObject {
  func didFinish(_ coordinator: OnboardingFlowCoordinator)
}

@MainActor
public final class OnboardingFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: OnboardingFlowCoordinatorDependencies
  
  public weak var delegate: OnboardingFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: OnboardingFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public func start() {
    let actions = OnboardingViewModelActions { [weak self] in
      guard let self else { return }
      
      self.delegate?.didFinish(self)
    }
    
    let viewController = dependencies.makeOnboardingViewController(actions: actions)
    
    navigationController?.setViewControllers([viewController], animated: false)
  }
  
}
