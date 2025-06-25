//
//  OnboardingCoordinator.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

final class OnboardingCoordinator {

  weak var navigationController: UINavigationController?
  var onFinish: (() -> Void)?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  func makeViewController() -> UIViewController {
    let onboardingVC = OnboardingViewController()

    onboardingVC.onFinish = { [weak self] in
      self?.onFinish?()
    }

    return onboardingVC
  }

}
