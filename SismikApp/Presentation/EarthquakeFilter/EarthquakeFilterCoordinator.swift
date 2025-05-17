//
//  EarthquakeFilterCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import CoreLocation
import SwiftUI

final class EarthquakeFilterCoordinator {

  private weak var navigationController: UINavigationController?
  private let coordinate: CLLocationCoordinate2D
  private let initialQuery: EarthquakeQuery
  private var onApply: ((EarthquakeQuery) -> Void)?
  var onCleanup: (() -> Void)?

  init(
    navigationController: UINavigationController?,
    coordinate: CLLocationCoordinate2D,
    initialQuery: EarthquakeQuery
  ) {
    self.navigationController = navigationController
    self.coordinate = coordinate
    self.initialQuery = initialQuery
  }

  func makeViewController(onApply: @escaping (EarthquakeQuery) -> Void) -> UIViewController {
    self.onApply = onApply

    let viewModel = DefaultEarthquakeFilterViewModel(
      initialQuery: initialQuery,
      coordinate: coordinate
    )

    viewModel.onApply = { [weak self] query in
      self?.onApply?(query)
      self?.navigationController?.dismiss(animated: true, completion: {
        self?.onCleanup?()
      })
    }

    viewModel.onDismiss = { [weak self] in
      self?.navigationController?.dismiss(animated: true)
    }

    let controller = EarthquakeFilterViewController(viewModel: viewModel)
    return controller
  }

}
