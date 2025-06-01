//
//  SceneDelegate.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appFlowCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let navigationController = AppNavigationControllerProvider.makeNavigationController()

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    appFlowCoordinator = AppCoordinator(navigationController: navigationController)
    appFlowCoordinator?.start()
  }

}
