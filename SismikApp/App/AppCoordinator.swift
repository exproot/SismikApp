//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

final class AppCoordinator {

  var window: UIWindow
  private var tabBarController: UITabBarController

  private var onboardingCoordinator: OnboardingCoordinator?
  private var dashboardCoordinator: EarthquakeDashboardCoordinator?
  private var earthquakeListCoordinator: EarthquakeListCoordinator?

  init(window: UIWindow) {
    self.window = window
    self.tabBarController = UITabBarController()
  }

  func start() {
    if !UserDefaults.standard.hasSeenOnboarding {
      showOnboarding()
    } else {
      showMainApp()
    }
  }

  private func showOnboarding() {
    let onboardingCoordinator = OnboardingCoordinator(navigationController: UINavigationController())
    self.onboardingCoordinator = onboardingCoordinator

    onboardingCoordinator.onFinish = { [weak self] in
      UserDefaults.standard.hasSeenOnboarding = true
      self?.showMainApp()
      self?.onboardingCoordinator = nil
    }

    window.rootViewController = onboardingCoordinator.makeViewController()
    window.makeKeyAndVisible()
  }

  private func showMainApp() {
    let dashboardNav = UINavigationController()
    let dashboardCoordinator = EarthquakeDashboardCoordinator(navigationController: dashboardNav)
    let dashboardVC = dashboardCoordinator.makeViewController()

    dashboardNav.setViewControllers([dashboardVC], animated: false)
    dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)

    let listNav = UINavigationController()
    let earthquakeListCoordinator = EarthquakeListCoordinator(navigationController: listNav)
    let listVC = earthquakeListCoordinator.makeViewController()

    listNav.setViewControllers([listVC], animated: false)
    listNav.tabBarItem = UITabBarItem(title: "Earthquakes", image: UIImage(systemName: "list.bullet"), tag: 1)

    self.dashboardCoordinator = dashboardCoordinator
    self.earthquakeListCoordinator = earthquakeListCoordinator

    tabBarController.viewControllers = [dashboardNav, listNav]
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }

}
