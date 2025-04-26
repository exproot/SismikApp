//
//  LocationAccessCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

final class LocationAccessCoordinator {

  weak var navigationController: UINavigationController?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let view = LocationAccessView()
    let hostingVC = UIHostingController(rootView: view)

    return hostingVC
  }

}
