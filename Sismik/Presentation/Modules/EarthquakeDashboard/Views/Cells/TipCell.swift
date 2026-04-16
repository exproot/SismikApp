//
//  TipCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.06.2025.
//

import UIKit

final class TipCell: UICollectionViewCell {

  static let reuseIdentifier = String(describing: TipCell.self)

  private let iconView = UIImageView()
  private let tipLabel = UILabel()
  private let stackView = UIStackView()


  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.shadowPath = UIBezierPath(
      roundedRect: contentView.bounds,
      cornerRadius: contentView.layer.cornerRadius
    ).cgPath
  }

  func configure(with text: String) {
    tipLabel.text = text
  }

  private func setupViews() {
    iconView.image = UIImage(systemName: "lightbulb")
    iconView.tintColor = .systemYellow
    iconView.contentMode = .scaleAspectFit
    iconView.setContentHuggingPriority(.required, for: .horizontal)
    iconView.translatesAutoresizingMaskIntoConstraints = false

    tipLabel.numberOfLines = 0
    tipLabel.font = .italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
    tipLabel.textColor = .secondaryLabel

    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(iconView)
    stackView.addArrangedSubview(tipLabel)

    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 12
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.08
    contentView.layer.shadowRadius = 4
    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)

    contentView.addSubview(stackView)

    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 28),
      iconView.heightAnchor.constraint(equalToConstant: 28),

      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
}
