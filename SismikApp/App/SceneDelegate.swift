//
//  SceneDelegate.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let navigationController = AppNavigationControllerProvider.makeNavigationController()
    let earthquakeListVC = EarthquakeListCoordinator(navigationController: navigationController).makeViewController()

    navigationController.setViewControllers([earthquakeListVC], animated: false)

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
  }

}
