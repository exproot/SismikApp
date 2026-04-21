//
//  SectionHeaderView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 27.06.2025.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: SectionHeaderView.self)

  private let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(title: String?) {
    titleLabel.text = title
  }

  private func setup() {
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.textColor = .label
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
    ])
  }

}
