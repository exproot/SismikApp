//
//  SceneDelegate.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  var diContainer: AppDIContainer?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let diContainer = AppDIContainer()

    self.window = window
    self.diContainer = diContainer

    let appCoordinator = AppCoordinator(window: window, diContainer: diContainer)
    self.appCoordinator = appCoordinator
    appCoordinator.start()
  }

}
