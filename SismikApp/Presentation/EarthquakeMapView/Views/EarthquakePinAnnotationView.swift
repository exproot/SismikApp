//
//  EarthquakePinAnnotationView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 16.05.2025.
//

import Combine
import UIKit
import MapKit

final class EarthquakePinAnnotationView: MKAnnotationView {

  static let reuseIdentifier = "EarthquakePin"

  private let label = UILabel()
  private let container = UIView()

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setupUI()
    animatePopIn()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with magnitude: Double) {
    label.text = String(format: "%.1f", magnitude)

    backgroundColor = .clear
    container.backgroundColor = magnitude.magnitudeColor()
  }

  private func animatePopIn() {
    transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    alpha = 0.0

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: []) {
      self.transform = .identity
      self.alpha = 1.0
    }
  }

  private func setupUI() {
    frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    backgroundColor = .clear

    container.frame = bounds
    container.backgroundColor = .systemBlue
    container.layer.cornerRadius = bounds.width / 2
    container.layer.borderColor = UIColor.label.cgColor
    container.layer.borderWidth = 2
    container.clipsToBounds = true
    container.translatesAutoresizingMaskIntoConstraints = false

    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .boldSystemFont(ofSize: 13)
    label.textColor = .label
    label.textAlignment = .center

    container.addSubview(label)
    addSubview(container)

    NSLayoutConstraint.activate([
      container.widthAnchor.constraint(equalToConstant: 40),
      container.heightAnchor.constraint(equalToConstant: 40),
      container.centerXAnchor.constraint(equalTo: centerXAnchor),
      container.centerYAnchor.constraint(equalTo: centerYAnchor),

      label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])


  }

}
