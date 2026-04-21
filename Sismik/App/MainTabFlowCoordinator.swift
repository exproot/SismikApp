//
//  MainTabFlowCoordinator.swift
//  Sismik
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import EarthquakeDomain
import CoreLocation
import UIKit
import EartquakeDetailPresentation
import LocationAccessPresentation
import DashboardPresentation
import ExplorePresentation
import MapPresentation

@MainActor
final class MainTabFlowCoordinator: NSObject {
  
  private let window: UIWindow
  private let diContainer: AppDIContainer
  private let tabBarController = UITabBarController()
  
  private var dashboardNavigationController: UINavigationController?
  private var exploreNavigationController: UINavigationController?
  
  private var earthquakeDetailCoordinators = [EarthquakeDetailFlowCoordinator]()
  private var earthquakeMapCoordinators = [MapFlowCoordinator]()
  
  private var dashboardCoordinator: DashboardFlowCoordinator?
  private var exploreCoordinator: ExploreFlowCoordinator?
  private var locationAccessCoordinator: LocationAccessFlowCoordinator?
  
  init(window: UIWindow, diContainer: AppDIContainer) {
    self.window = window
    self.diContainer = diContainer
  }
  
  func start() {
    let dashboardNav = UINavigationController()
    dashboardNav.delegate = self
    self.dashboardNavigationController = dashboardNav

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
    exploreNav.delegate = self
    self.exploreNavigationController = exploreNav
    
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
    
    earthquakeDetailCoordinators.append(detailCoordinator)
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
    
    earthquakeMapCoordinators.append(mapCoordinator)
    mapCoordinator.start()
  }
  
  private func showLocationAccess(navigationController: UINavigationController?) {
    guard let navigationController else { return }
    let locationAccessModule = diContainer.makeLocationAccessModule()
    let locationAccessCoordinator = locationAccessModule.makeFlowCoordinator(navigationController: navigationController)
    locationAccessCoordinator.delegate = self
    
    self.locationAccessCoordinator = locationAccessCoordinator
    locationAccessCoordinator.start()
  }
  
}

// MARK: UINavigationControllerDelegate
extension MainTabFlowCoordinator: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    cleanupDetailFlowsIfNeeded(in: navigationController)
    cleanupMapFlowsIfNeeded(in: navigationController)
  }
  
  private func cleanupDetailFlowsIfNeeded(in navigationController: UINavigationController) {
    earthquakeDetailCoordinators.removeAll { coordinator in
      guard coordinator.rootNavigationController === navigationController,
            let rootViewController = coordinator.trackedRootViewController
      else {
        return false
      }
      
      return !navigationController.viewControllers.contains { $0 === rootViewController }
    }
  }
  
  private func cleanupMapFlowsIfNeeded(in navigationController: UINavigationController) {
    earthquakeMapCoordinators.removeAll { coordinator in
      guard coordinator.rootNavigationController === navigationController,
            let rootViewController = coordinator.trackedRootViewController
      else {
        return false
      }
      
      return !navigationController.viewControllers.contains { $0 === rootViewController }
    }
  }
}

// MARK: EarthquakeDetailFlowCoordinatorDelegate
extension MainTabFlowCoordinator: EarthquakeDetailFlowCoordinatorDelegate {
  func earthquakeDetailFlowCoordinator(
    _ coordinator: EarthquakeDetailFlowCoordinator,
    didRequestMapFor earthquake: Earthquake
  ) {
    showMap(for: [earthquake], in: CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude), navigationController: coordinator.rootNavigationController)
  }
}

// MARK: LocationAccessFlowCoordinatorDelegate
extension MainTabFlowCoordinator: LocationAccessFlowCoordinatorDelegate {
  func locationAccessFlowCoordinatorDidRequestOpenAppSettings(_ coordinator: LocationAccessFlowCoordinator) {
    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
      if UIApplication.shared.canOpenURL(settingsURL) {
        UIApplication.shared.open(settingsURL)
      }
    }
    
    finishLocationAccessFlow()
  }
  
  func locationAccessFlowCoordinatorDidFinish(_ coordinator: LocationAccessFlowCoordinator) {
    finishLocationAccessFlow()
  }
  
  private func finishLocationAccessFlow() {
    tabBarController.presentedViewController?.dismiss(animated: true)
    locationAccessCoordinator = nil
  }
}

// MARK: DashboardFlowCoordinatorDelegate
extension MainTabFlowCoordinator: DashboardFlowCoordinatorDelegate {
  func dashboardFlowCoordinator(
    _ coordinator: DashboardFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  ) {
    showDetail(for: earthquake, navigationController: coordinator.rootNavigationController)
  }
  
  func dashboardFlowCoordinatorDidRequestLocationDenied(_ coordinator: DashboardFlowCoordinator) {
    showLocationAccess(navigationController: coordinator.rootNavigationController)
  }
}

// MARK: ExploreFlowCoordinatorDelegate
extension MainTabFlowCoordinator: ExploreFlowCoordinatorDelegate {
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
    showMap(
      for: earthquakes,
      with: radius,
      in: center,
      navigationController: coordinator.rootNavigationController
    )
  }
}
