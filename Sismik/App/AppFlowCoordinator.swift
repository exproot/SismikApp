//
//  AppFlowCoordinator.swift
//  Sismik
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import UIKit
import OnboardingPresentation

@MainActor
final class AppFlowCoordinator {
  
  private let window: UIWindow
  private let diContainer: AppDIContainer
  
  private var onboardingFlowCoordinator: OnboardingFlowCoordinator?
  private var mainTabFlowCoordinator: MainTabFlowCoordinator?
  
  init(window: UIWindow, diContainer: AppDIContainer) {
    self.window = window
    self.diContainer = diContainer
  }
  
  func start() {
    if !AppPreferences.hasSeenOnboarding {
      showOnboarding()
    } else {
      showMainTabs()
    }
  }
  
  private func showOnboarding() {
    let navigationController = UINavigationController()
    let onboardingModule = diContainer.makeOnboardingModule()
    let onboardingCoordinator = onboardingModule.makeFlowCoordinator(
      navigationController: navigationController
    )
    onboardingCoordinator.delegate = self
    
    self.onboardingFlowCoordinator = onboardingCoordinator
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    onboardingCoordinator.start()
  }
  
  private func showMainTabs() {
    let coordinator = MainTabFlowCoordinator(window: window, diContainer: diContainer)
    
    self.mainTabFlowCoordinator = coordinator
    coordinator.start()
  }
  
}

// MARK: OnboardingFlowCoordinatorDelegate
extension AppFlowCoordinator: OnboardingFlowCoordinatorDelegate {
  func didFinish(_ coordinator: OnboardingFlowCoordinator) {
    AppPreferences.hasSeenOnboarding = true
    onboardingFlowCoordinator = nil
    showMainTabs()
  }
}

