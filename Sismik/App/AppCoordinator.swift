//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import DashboardPresentation
import EarthquakeDomain
import UIKit

@MainActor
final class AppCoordinator {

  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let diContainer: AppDIContainer

  private var onboardingCoordinator: OnboardingCoordinator?
  private var dashboardCoordinator: DashboardFlowCoordinator?
  private var earthquakeExploreCoordinator: EarthquakeExploreCoordinator?

  init(
    window: UIWindow,
    diContainer: AppDIContainer
  ) {
    self.window = window
    self.tabBarController = UITabBarController()
    self.diContainer = diContainer
  }

  func start() {
    if !AppPreferences.hasSeenOnboarding {
      showOnboarding()
    } else {
      showMainApp()
    }
  }

  private func showOnboarding() {
    let onboardingCoordinator = OnboardingCoordinator(navigationController: UINavigationController())
    self.onboardingCoordinator = onboardingCoordinator

    onboardingCoordinator.onFinish = { [weak self] in
      AppPreferences.hasSeenOnboarding = true
      self?.showMainApp()
      self?.onboardingCoordinator = nil
    }

    window.rootViewController = onboardingCoordinator.makeViewController()
    window.makeKeyAndVisible()
  }

  private func showMainApp() {
    let dashboardNav = UINavigationController()
    dashboardNav.tabBarItem = UITabBarItem(
      title: NSLocalizedString("tabbar.dashboard", comment: ""),
      image: UIImage(systemName: "house"),
      tag: 0
    )
    
    let dashboardModule = diContainer.makeDashboardModule()
    let dashboardCoordinator = dashboardModule.makeFlowCoordinator(navigationController: dashboardNav)
    dashboardCoordinator.delegate = self
    
    self.dashboardCoordinator = dashboardCoordinator
    dashboardCoordinator.start()

    let exploreNav = UINavigationController()
    let earthquakeExploreCoordinator = EarthquakeExploreCoordinator(navigationController: exploreNav)
    let exploreVC = earthquakeExploreCoordinator.makeViewController()

    exploreNav.setViewControllers([exploreVC], animated: false)
    exploreNav.tabBarItem = UITabBarItem(
      title: NSLocalizedString("tabbar.explore", comment: ""),
      image: UIImage(systemName: "globe.europe.africa"),
      tag: 1
    )
    
    self.earthquakeExploreCoordinator = earthquakeExploreCoordinator

    tabBarController.viewControllers = [dashboardNav, exploreNav]
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }

}

// MARK: DashboardFlowCoordinatorDelegate
extension AppCoordinator: DashboardFlowCoordinatorDelegate {
  
  func dashboardFlowCoordinator(
    _ coordinator: DashboardFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  ) {
    let earthquakeDetailCoordinator = EarthquakeDetailCoordinator(navigationController: coordinator.rootNavigationController, earthquake: earthquake)
    let earthquakeDetailVC = earthquakeDetailCoordinator.makeViewController()
    
    earthquakeDetailCoordinator.navigationController?.pushViewController(earthquakeDetailVC, animated: true)
  }
  
  func dashboardFlowCoordinatorDidRequestLocationDenied(_ coordinator: DashboardPresentation.DashboardFlowCoordinator) {
    let locationAccessCoordinator = LocationAccessCoordinator(navigationController: coordinator.rootNavigationController)
    let locationAccessVC = locationAccessCoordinator.makeViewController()
    
    coordinator.rootNavigationController?.present(locationAccessVC, animated: true)
  }
  
}
