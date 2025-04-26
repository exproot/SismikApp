//
//  EarthquakeDetailCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

final class EarthquakeDetailCoordinator {

  weak var navigationController: UINavigationController?
  private let earthquake: Earthquake

  init(navigationController: UINavigationController?, earthquake: Earthquake) {
    self.navigationController = navigationController
    self.earthquake = earthquake
  }

  func makeViewController() -> UIViewController {
    let viewModel = EarthquakeDetailViewModel(earthquake: earthquake)
    let detailView = EarthquakeDetailView(viewModel: viewModel)
    let hostingVC = UIHostingController(rootView: detailView)
    return hostingVC
  }

}
