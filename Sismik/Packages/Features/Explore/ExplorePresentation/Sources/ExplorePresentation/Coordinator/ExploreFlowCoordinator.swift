//
//  ExploreFlowCoordinator.swift
//  ExplorePresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import CoreLocation
import EarthquakeDomain
import UIKit

@MainActor
protocol ExploreFlowCoordinatorDependencies {
  func makeExploreScene(actions: ExploreViewModelActions) -> ExploreScene
}

public protocol ExploreFlowCoordinatorDelegate: AnyObject {
  func exploreFlowCoordinator(
    _ coordinator: ExploreFlowCoordinator,
    didRequestDetailFor earthquake: Earthquake
  )
  
  func exploreFlowCoordinator(
    _ coordinator: ExploreFlowCoordinator,
    didRequestMapFor earthquakes: [Earthquake],
    radius: Double,
    center: CLLocationCoordinate2D
  )
}

@MainActor
public final class ExploreFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: ExploreFlowCoordinatorDependencies
  private var exploreScene: ExploreScene?
  
  public weak var delegate: ExploreFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: ExploreFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public var rootNavigationController: UINavigationController? {
    navigationController
  }
  
  public func start() {
    let actions = ExploreViewModelActions(
      didSelectEarthquake: { [weak self] earthquake in
        guard let self else { return }
        
        self.delegate?.exploreFlowCoordinator(self, didRequestDetailFor: earthquake)
      },
      didRequestMap: { [weak self] earthquakes, radius, center in
        guard let self else { return }
        
        self.delegate?.exploreFlowCoordinator(self, didRequestMapFor: earthquakes, radius: radius, center: center)
      },
      didRequestFilter: { [weak self] options in
        guard let self else { return }
        
        self.showFilter(options: options)
      }
    )
    
    let scene =  dependencies.makeExploreScene(actions: actions)
    self.exploreScene = scene
    
    navigationController?.setViewControllers([scene.viewController], animated: true)
  }
  
  private func showFilter(options: EarthquakeFilterOptions) {
    let actions = EarthquakeFilterViewModelActions(
      didSelectApply: { [weak self] options in
        guard let self else { return }
        
        self.exploreScene?.filterApplying.applyFilter(options)
        self.navigationController?.dismiss(animated: true)
      },
      didSelectCancel: { [weak self] in
        self?.navigationController?.dismiss(animated: true)
      }
    )
    
    let filterViewModel = EarthquakeFilterViewModel(actions: actions, initialOptions: options)
    let filterController = EarthquakeFilterViewController(viewModel: filterViewModel)
    
    filterController.modalPresentationStyle = .pageSheet
    
    if let sheet = filterController.sheetPresentationController {
      sheet.detents = [.large()]
      sheet.prefersGrabberVisible = true
    }
    
    navigationController?.present(filterController, animated: true)
  }
  
}
