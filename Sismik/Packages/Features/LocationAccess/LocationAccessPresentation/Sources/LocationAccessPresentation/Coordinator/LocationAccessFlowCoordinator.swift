//
//  LocationAccessFlowCoordinator.swift
//  LocationAccessPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import SwiftUI

@MainActor
protocol LocationAccessFlowCoordinatorDependencies {
  func makeLocationAccessHostingController(
    actions: LocationAccessViewModelActions
  ) -> UIViewController
}

public protocol LocationAccessFlowCoordinatorDelegate: AnyObject {
  func locationAccessFlowCoordinatorDidRequestOpenAppSettings(_ coordinator: LocationAccessFlowCoordinator)
  func locationAccessFlowCoordinatorDidFinish(_ coordinator: LocationAccessFlowCoordinator)
}

@MainActor
public final class LocationAccessFlowCoordinator: NSObject {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: LocationAccessFlowCoordinatorDependencies
  
  public weak var delegate: LocationAccessFlowCoordinatorDelegate?
  
  init(
    navigationController: UINavigationController,
    dependencies: LocationAccessFlowCoordinatorDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  public func start() {
    let actions = LocationAccessViewModelActions(
      didRequestOpenSettings: { [weak self] in
        guard let self else { return }
        
        self.delegate?.locationAccessFlowCoordinatorDidRequestOpenAppSettings(self)
      },
      didRequestClose: { [weak self] in
        guard let self else { return }
        
        self.delegate?.locationAccessFlowCoordinatorDidFinish(self)
      }
    )
    
    let viewController = dependencies.makeLocationAccessHostingController(actions: actions)
    viewController.presentationController?.delegate = self
    
    navigationController?.present(viewController, animated: true)
  }
  
}

// MARK: UIAdaptivePresentationControllerDelegate
extension LocationAccessFlowCoordinator: UIAdaptivePresentationControllerDelegate {
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.locationAccessFlowCoordinatorDidFinish(self)
  }
}
