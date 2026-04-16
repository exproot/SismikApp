//
//  RecentEarthquakeCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class RecentEarthquakeCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: RecentEarthquakeCell.self)

  private let iconView = UIImageView()
  private let titleLabel = UILabel()
  private let magLabel = UILabel()
  private let stackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }

  required init?(coder: NSCoder) { fatalError() }

  func configure(with quake: Earthquake) {
    titleLabel.text = quake.title

    magLabel.text = String(
      format: NSLocalizedString("dashboard.magnitude", comment: ""),
      quake.magnitude
    )
    iconView.image = UIImage(systemName: "waveform.path.ecg")
  }

  private func setupLayout() {
    iconView.tintColor = .tintColor
    iconView.contentMode = .scaleAspectFit
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.setContentHuggingPriority(.required, for: .horizontal)

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 2

    magLabel.font = .preferredFont(forTextStyle: .subheadline)
    magLabel.textColor = .secondaryLabel

    let textStack = UIStackView(arrangedSubviews: [titleLabel, magLabel])
    textStack.axis = .vertical
    textStack.spacing = 4

    stackView.axis = .horizontal
    stackView.spacing = 12
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(iconView)
    stackView.addArrangedSubview(textStack)

    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 12

    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 28),
      iconView.heightAnchor.constraint(equalToConstant: 28),

      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
    ])
  }

}
