//
//  EarthquakeListCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class EarthquakeListCell: UITableViewCell {

  static let reuseIdentifier = String(describing: EarthquakeListCell.self)

  // MARK: UI Components
  private let titleLabel = UILabel()
  private let magnitudeLabel = UILabel()
  private let timeLabel = UILabel()
  private let stackView = UIStackView()

  // MARK: Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(with earthquake: Earthquake) {
    titleLabel.text = earthquake.title
    magnitudeLabel.text = String(format: NSLocalizedString("explore.magnitude", comment: "") + ": %.1f", earthquake.magnitude)
    magnitudeLabel.textColor = earthquake.magnitude.magnitudeColor()

    timeLabel.text = earthquake.time.formatEarthquakeDate()
  }

  // MARK: Setup
  private func setupViews() {
    selectionStyle = .default

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    magnitudeLabel.font = .preferredFont(forTextStyle: .subheadline)
    timeLabel.font = .preferredFont(forTextStyle: .caption1)
    timeLabel.textColor = .secondaryLabel

    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(magnitudeLabel)
    stackView.addArrangedSubview(timeLabel)
    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
}
