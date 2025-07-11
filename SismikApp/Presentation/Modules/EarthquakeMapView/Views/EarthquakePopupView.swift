//
//  EarthquakePopupView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import UIKit

final class EarthquakePopupView: UIView {

  private let titleLabel = UILabel()
  private let magnitudeLabel = UILabel()
  private let dateLabel = UILabel()

  init(earthquake: Earthquake) {
    super.init(frame: .zero)
    setupUI()
    configure(with: earthquake)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure(with quake: Earthquake) {
    titleLabel.text = quake.title

    magnitudeLabel.text = String(
      format: NSLocalizedString("map.popup.magnitude", comment: ""),
      quake.magnitude
    )

    dateLabel.text = quake.time.formatEarthquakeDate()
    magnitudeLabel.textColor = quake.magnitude.magnitudeColor()
  }

  private func setupUI() {
    backgroundColor = .systemBackground.withAlphaComponent(0.8)
    layer.cornerRadius = 12
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 5

    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0

    magnitudeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    magnitudeLabel.textAlignment = .center

    dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    dateLabel.textColor = .secondaryLabel
    dateLabel.textAlignment = .center

    let stack = UIStackView(arrangedSubviews: [titleLabel, magnitudeLabel, dateLabel])
    stack.axis = .vertical
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }

}
