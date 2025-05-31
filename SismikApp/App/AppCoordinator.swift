//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//


import UIKit

final class AppCoordinator {

  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    UserDefaults.standard.hasSeenOnboarding = false
    if !UserDefaults.standard.hasSeenOnboarding {
      showOnboarding()
    } else {
      showMainApp()
    }
  }

  private func showOnboarding() {
    let onboardingVC = OnboardingCoordinator(navigationController: navigationController).makeViewController()

    navigationController.setViewControllers([onboardingVC], animated: false)
  }

  private func showMainApp() {
    let earthquakeListVC = EarthquakeListCoordinator(navigationController: navigationController).makeViewController()

    navigationController.setViewControllers([earthquakeListVC], animated: false)
  }
}
