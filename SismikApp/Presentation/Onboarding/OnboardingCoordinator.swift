//
//  OnboardingCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

class OnboardingCoordinator {
  weak var navigationController: UINavigationController?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let onboardingVC = OnboardingViewController()

    onboardingVC.onFinish = showEarthquakeList

    return onboardingVC
  }

  private func showEarthquakeList() {
    let listVC = EarthquakeListCoordinator(navigationController: navigationController).makeViewController()

    UserDefaults.standard.hasSeenOnboarding = true
    navigationController?.setViewControllers([listVC], animated: true)
  }
}
