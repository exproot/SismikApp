//
//  UIViewController+Alert.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 9.07.2025.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String, buttonTitle: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
    present(alert, animated: true)
  }
}
