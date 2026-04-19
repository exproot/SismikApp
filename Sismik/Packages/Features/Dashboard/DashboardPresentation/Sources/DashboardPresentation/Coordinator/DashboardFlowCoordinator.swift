//
//  DashboardFlowCoordinator.swift
//  DashboardPresentation
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import CoreLocation
import EarthquakeDomain
import UIKit

@MainActor
protocol DashboardFlowCoordinatorDependencies {
  func makeDashboardViewController(actions: DashboardViewModelActions) -> UIViewController
}

public protocol DashboardFlowCoordinatorDelegate: AnyObject {
  func dashboardFlowCoordinator(
    _ coordinator: DashboardFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  )
  
  func dashboardFlowCoordinatorDidRequestLocationDenied(_ coordinator: DashboardFlowCoordinator)
}

@MainActor
public final class DashboardFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: DashboardFlowCoordinatorDependencies
  
  public weak var delegate: DashboardFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: DashboardFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public var rootNavigationController: UINavigationController? {
    navigationController
  }
  
  public func start() {
    let actions = DashboardViewModelActions(
      didSelectEarthquake: { [weak self] earthquake in
        guard let self else { return }
        self.delegate?.dashboardFlowCoordinator(self, didRequestDetailFor: earthquake)
      },
      showLocationDenied: { [weak self] in
        guard let self else { return }
        self.delegate?.dashboardFlowCoordinatorDidRequestLocationDenied(self)
      }
    )
    
    let viewController = dependencies.makeDashboardViewController(actions: actions)
    navigationController?.setViewControllers([viewController], animated: true)
  }
  
}
