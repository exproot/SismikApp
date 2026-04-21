//
//  EarthquakeDetailFlowCoordinator.swift
//  EarthquakeDetail
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import CoreLocation
import EarthquakeDomain
import UIKit

@MainActor
protocol EarthquakeDetailFlowCoordinatorDependencies {
  func makeEarthquakeDetailViewController(actions: EarthquakeDetailViewModelActions) -> UIViewController
}

public protocol EarthquakeDetailFlowCoordinatorDelegate: AnyObject {
  func earthquakeDetailFlowCoordinator(
    _ coordinator: EarthquakeDetailFlowCoordinator,
    didRequestMapFor earthquake: Earthquake
  )
}

@MainActor
public final class EarthquakeDetailFlowCoordinator {
  
  private let dependencies: EarthquakeDetailFlowCoordinatorDependencies
  
  private weak var navigationController: UINavigationController?
  private weak var rootViewController: UIViewController?
  
  public weak var delegate: EarthquakeDetailFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: EarthquakeDetailFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public var rootNavigationController: UINavigationController? {
    navigationController
  }
  
  public var trackedRootViewController: UIViewController? {
    rootViewController
  }
  
  public func start() {
    let actions = EarthquakeDetailViewModelActions(
      didRequestMap: { [weak self] earthquake in
        guard let self else { return }
        
        self.delegate?.earthquakeDetailFlowCoordinator(self, didRequestMapFor: earthquake)
      }
    )
    
    let viewController = dependencies.makeEarthquakeDetailViewController(actions: actions)
    rootViewController = viewController
    
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}
