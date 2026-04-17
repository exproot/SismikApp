//
//  EarthquakeFilterCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import EarthquakeDomain
import UIKit

final class EarthquakeFilterCoordinator {

  private weak var navigationController: UINavigationController?
  private let initialOptions: EarthquakeFilterOptions
  private var onApply: ((EarthquakeFilterOptions) -> Void)?
  var onCleanup: (() -> Void)?

  init(
    navigationController: UINavigationController?,
    initialOptions: EarthquakeFilterOptions
  ) {
    self.navigationController = navigationController
    self.initialOptions = initialOptions
  }

  func makeViewController(onApply: @escaping (EarthquakeFilterOptions) -> Void) -> EarthquakeFilterViewController {
    self.onApply = onApply

    let viewModel = DefaultEarthquakeFilterViewModel(initialOptions: initialOptions)

    viewModel.onApply = { [weak self] options in
      self?.onApply?(options)
      self?.navigationController?.dismiss(animated: true) {
        self?.onCleanup?()
      }
    }

    viewModel.onDismiss = { [weak self] in
      self?.navigationController?.dismiss(animated: true) {
        self?.onCleanup?()
      }
    }

    let controller = EarthquakeFilterViewController(viewModel: viewModel)
    return controller
  }

}
