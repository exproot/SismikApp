//
//  BiggestEarthquakeCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.06.2025.
//

import EarthquakeDomain
import UIKit

final class BiggestEarthquakeCell: UICollectionViewCell {

  static let reuseIdentifier = String(describing: BiggestEarthquakeCell.self)

  // MARK: - UI Elements
  private let verticalBar: UIView = {
    let view = UIView()
    view.backgroundColor = .systemRed
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 3
    return view
  }()

  private let iconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "waveform.path.ecg"))
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("dashboard.biggest.title", comment: "")
    label.font = .preferredFont(forTextStyle: .subheadline)
    label.textColor = .white
    return label
  }()

  private let magnitudeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .bold)
    label.textColor = .white
    return label
  }()

  private let locationLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = .white
    return label
  }()

  private let timeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = .white.withAlphaComponent(0.85)
    return label
  }()

  private let backgroundGradient = CAGradientLayer()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradient()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundGradient.frame = contentView.bounds
  }

  private func setupGradient() {
    backgroundGradient.colors = [
      UIColor.systemOrange.cgColor,
      UIColor.systemRed.cgColor,
      UIColor.systemRed.withAlphaComponent(0.8).cgColor
    ]
    backgroundGradient.locations = [0.0, 0.7, 1.0]
    backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
    backgroundGradient.endPoint = CGPoint(x: 1, y: 1)
    backgroundGradient.cornerRadius = 12
    contentView.layer.insertSublayer(backgroundGradient, at: 0)
  }


  func configure(with quake: Earthquake) {
    titleLabel.text = NSLocalizedString("dashboard.biggest.title", comment: "")
    magnitudeLabel.text = String(format: "%.1fM", quake.magnitude)
    locationLabel.text = quake.title
    timeLabel.text = quake.time.timeAgoString()
  }

  private func setupLayout() {
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true

    let infoStack = UIStackView(arrangedSubviews: [titleLabel, magnitudeLabel, locationLabel, timeLabel])
    infoStack.axis = .vertical
    infoStack.spacing = 4

    let mainStack = UIStackView(arrangedSubviews: [verticalBar, iconView, infoStack])
    mainStack.axis = .horizontal
    mainStack.alignment = .center
    mainStack.spacing = 12
    mainStack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(mainStack)

    NSLayoutConstraint.activate([
      verticalBar.widthAnchor.constraint(equalToConstant: 6),
      verticalBar.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.8),

      iconView.widthAnchor.constraint(equalToConstant: 24),
      iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),

      mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
    ])
  }

}
