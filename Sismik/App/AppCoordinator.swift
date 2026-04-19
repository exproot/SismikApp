//
//  AppCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import EarthquakeDomain
import CoreLocation
import UIKit
import EartquakeDetailPresentation
import DashboardPresentation
import ExplorePresentation
import MapPresentation


@MainActor
final class AppCoordinator {

  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let diContainer: AppDIContainer

  private var onboardingCoordinator: OnboardingCoordinator?
  private var dashboardCoordinator: DashboardFlowCoordinator?
  private var exploreCoordinator: ExploreFlowCoordinator?
  private var earthquakeDetailCoordinator: EarthquakeDetailFlowCoordinator?
  private var earthquakeMapCoordinator: MapFlowCoordinator?

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
    exploreNav.tabBarItem = UITabBarItem(
      title: NSLocalizedString("tabbar.explore", comment: ""),
      image: UIImage(systemName: "globe.europe.africa"),
      tag: 1
    )
    
    let exploreModule = diContainer.makeExploreModule()
    let exploreCoordinator = exploreModule.makeFlowCoordinator(navigationController: exploreNav)
    exploreCoordinator.delegate = self
  
    self.exploreCoordinator = exploreCoordinator
    exploreCoordinator.start()

    tabBarController.viewControllers = [dashboardNav, exploreNav]
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }
  
  private func showDetail(
    for earthquake: Earthquake,
    navigationController: UINavigationController?
  ) {
    guard let navigationController else { return }
    
    let context = EarthquakeDetailContext(earthquake: earthquake)
    let detailModule = diContainer.makeEarthquakeDetailModule(with: context)
    let detailCoordinator = detailModule.makeFlowCoordinator(navigationController: navigationController)
    detailCoordinator.delegate = self
    
    self.earthquakeDetailCoordinator = detailCoordinator
    detailCoordinator.start()
  }
  
  private func showMap(
    for earthquakes: [Earthquake],
    with radius: Double? = nil,
    in location: CLLocationCoordinate2D,
    navigationController: UINavigationController?
  ) {
    guard let navigationController else { return }
    
    let context = EarthquakeMapContext(
      earthquakes: earthquakes,
      radius: radius,
      center: location
    )
    
    let mapModule = diContainer.makeMapModule(with: context)
    let mapCoordinator = mapModule.makeFlowCoordinator(navigationController: navigationController)
    
    self.earthquakeMapCoordinator = mapCoordinator
    mapCoordinator.start()
  }

}

// MARK: EarthquakeDetailFlowCoordinatorDelegate
extension AppCoordinator: EarthquakeDetailFlowCoordinatorDelegate {
  func earthquakeDetailFlowCoordinator(
    _ coordinator: EarthquakeDetailFlowCoordinator,
    didRequestMapFor earthquake: Earthquake
  ) {
    showMap(for: [earthquake], in: CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude), navigationController: coordinator.rootNavigationController)
  }
}

// MARK: ExploreFlowCoordinatorDelegate
extension AppCoordinator: ExploreFlowCoordinatorDelegate {

  func exploreFlowCoordinator(
    _ coordinator: ExploreFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  ) {
    showDetail(for: earthquake, navigationController: coordinator.rootNavigationController)
  }
  
  func exploreFlowCoordinator(
    _ coordinator: ExploreFlowCoordinator,
    didRequestMapFor earthquakes: [Earthquake],
    radius: Double,
    center: CLLocationCoordinate2D
  ) {
    showMap(for: earthquakes, with: radius, in: center, navigationController: coordinator.rootNavigationController)
  }
  
}

// MARK: DashboardFlowCoordinatorDelegate
extension AppCoordinator: DashboardFlowCoordinatorDelegate {
  
  func dashboardFlowCoordinator(
    _ coordinator: DashboardFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  ) {
    showDetail(for: earthquake, navigationController: coordinator.rootNavigationController)
  }
  
  func dashboardFlowCoordinatorDidRequestLocationDenied(_ coordinator: DashboardPresentation.DashboardFlowCoordinator) {
    let locationAccessCoordinator = LocationAccessCoordinator(navigationController: coordinator.rootNavigationController)
    let locationAccessVC = locationAccessCoordinator.makeViewController()
    
    coordinator.rootNavigationController?.present(locationAccessVC, animated: true)
  }
  
}
