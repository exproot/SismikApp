//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

final class AppCoordinator {

  var navigationController: UINavigationController
  private var onboardingCoordinator: OnboardingCoordinator?
  private var earthquakeListCoordinator: EarthquakeListCoordinator?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    if !UserDefaults.standard.hasSeenOnboarding {
      showOnboarding()
    } else {
      showMainApp()
    }
  }

  private func showOnboarding() {
    let coordinator = OnboardingCoordinator(navigationController: navigationController)
    onboardingCoordinator = coordinator

    coordinator.onFinish = { [weak self] in
      UserDefaults.standard.hasSeenOnboarding = true
      self?.showMainApp()
      self?.onboardingCoordinator = nil
    }

    let onboardingVC = coordinator.makeViewController()
    navigationController.setViewControllers([onboardingVC], animated: false)
  }

  private func showMainApp() {
    let coordinator = EarthquakeListCoordinator(navigationController: navigationController)
    earthquakeListCoordinator = coordinator

    let earthquakeListVC = coordinator.makeViewController()

    navigationController.setViewControllers([earthquakeListVC], animated: false)
  }
}
