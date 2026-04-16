//
//  PlaceholderDashboardEmptyStateCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import UIKit

final class PlaceholderDashboardEmptyStateCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: PlaceholderDashboardEmptyStateCell.self)

  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) { fatalError() }

  func configure(with text: String) {
    label.text = text
  }

  private func setup() {
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    label.font = .italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
    label.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(label)

    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 12
  }
}
