//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

final class AppFlowCoordinator {
  
  private weak var tabBarController: UITabBarController?
 
  init(tabBarController: UITabBarController) {
    self.tabBarController = tabBarController
  }
  
  func start() {
    if !UserDefaults.standard.hasSeenOnboarding {
      
    } else {
      
    }
  }
  
}

final class AppCoordinator {

  var window: UIWindow
  private var tabBarController: UITabBarController

  private var onboardingCoordinator: OnboardingCoordinator?
  private var dashboardCoordinator: EarthquakeDashboardCoordinator?
  private var earthquakeExploreCoordinator: EarthquakeExploreCoordinator?

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
    dashboardNav.tabBarItem = UITabBarItem(
      title: NSLocalizedString("tabbar.dashboard", comment: ""),
      image: UIImage(systemName: "house"),
      tag: 0
    )

    let exploreNav = UINavigationController()
    let earthquakeExploreCoordinator = EarthquakeExploreCoordinator(navigationController: exploreNav)
    let exploreVC = earthquakeExploreCoordinator.makeViewController()

    exploreNav.setViewControllers([exploreVC], animated: false)
    exploreNav.tabBarItem = UITabBarItem(
      title: NSLocalizedString("tabbar.explore", comment: ""),
      image: UIImage(systemName: "globe.europe.africa"),
      tag: 1
    )

    self.dashboardCoordinator = dashboardCoordinator
    self.earthquakeExploreCoordinator = earthquakeExploreCoordinator

    tabBarController.viewControllers = [dashboardNav, exploreNav]
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }

}
