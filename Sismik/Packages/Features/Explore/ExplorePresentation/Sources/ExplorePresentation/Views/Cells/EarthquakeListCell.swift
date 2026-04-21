//
//  EarthquakeListCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import EarthquakeDomain
import UIKit

final class EarthquakeListCell: UITableViewCell {

  static let reuseIdentifier = String(describing: EarthquakeListCell.self)

  // MARK: UI Components
  private let containerView = UIView()
  private let magnitudeBadge = UILabel()
  private let titleLabel = UILabel()

  private let timeIcon = UIImageView()
  private let timeLabel = UILabel()
  private let locationIcon = UIImageView()
  private let locationLabel = UILabel()
  private let infoStack = UIStackView()
  private let textStack = UIStackView()

  private let gradientLayer = CAGradientLayer()

  // MARK: Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = containerView.bounds
  }

  // MARK: Configure
  func configure(with model: EnrichedEarthquake) {
    magnitudeBadge.text = String(format: "%.1f", model.earthquake.magnitude)
    magnitudeBadge.backgroundColor = model.earthquake.magnitude.magnitudeColor()
    magnitudeBadge.textColor = .white

    titleLabel.text = model.earthquake.title
    timeLabel.text = model.earthquake.time.formattedEarthquakeDisplayText()
    locationLabel.text = model.locationName
  }

  // MARK: Setup
  private func setupViews() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = UIColor(named: "AccentColor")
    containerView.layer.cornerRadius = 12
    containerView.clipsToBounds = true
    contentView.addSubview(containerView)

    magnitudeBadge.translatesAutoresizingMaskIntoConstraints = false
    magnitudeBadge.layer.borderWidth = 1
    magnitudeBadge.layer.borderColor = UIColor.white.cgColor
    magnitudeBadge.font = .boldSystemFont(ofSize: 16)
    magnitudeBadge.textAlignment = .center
    magnitudeBadge.layer.cornerRadius = 20
    magnitudeBadge.clipsToBounds = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .white
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 0

    locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
    locationIcon.tintColor = .white.withAlphaComponent(0.7)
    locationIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      locationIcon.widthAnchor.constraint(equalToConstant: 14),
      locationIcon.heightAnchor.constraint(equalToConstant: 14)
    ])

    locationLabel.font = .preferredFont(forTextStyle: .caption1)
    locationLabel.textColor = .white.withAlphaComponent(0.7)
    locationLabel.numberOfLines = 1

    timeIcon.image = UIImage(systemName: "clock")
    timeIcon.tintColor = .white.withAlphaComponent(0.7)
    timeIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeIcon.widthAnchor.constraint(equalToConstant: 14),
      timeIcon.heightAnchor.constraint(equalToConstant: 14)
    ])

    timeLabel.font = .preferredFont(forTextStyle: .caption1)
    timeLabel.textColor = .white.withAlphaComponent(0.7)
    timeLabel.numberOfLines = 1

    let locationStack = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
    locationStack.axis = .horizontal
    locationStack.spacing = 4
    locationStack.alignment = .center

    let timeStack = UIStackView(arrangedSubviews: [timeIcon, timeLabel])
    timeStack.axis = .horizontal
    timeStack.spacing = 4
    timeStack.alignment = .center
    timeStack.distribution = .fill

    infoStack.axis = .vertical
    infoStack.spacing = 2
    infoStack.addArrangedSubview(locationStack)
    infoStack.addArrangedSubview(timeStack)

    textStack.axis = .vertical
    textStack.spacing = 8
    textStack.translatesAutoresizingMaskIntoConstraints = false
    textStack.addArrangedSubview(titleLabel)
    textStack.addArrangedSubview(infoStack)

    containerView.addSubview(magnitudeBadge)
    containerView.addSubview(textStack)

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

      magnitudeBadge.widthAnchor.constraint(equalToConstant: 40),
      magnitudeBadge.heightAnchor.constraint(equalToConstant: 40),
      magnitudeBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      magnitudeBadge.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

      textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
      textStack.leadingAnchor.constraint(equalTo: magnitudeBadge.trailingAnchor, constant: 16),
      textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
    ])
  }
}
