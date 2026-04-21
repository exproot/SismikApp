//
//  StatView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.06.2025.
//

import UIKit

final class StatView: UIView {
  private let iconView = UIImageView()
  private let valueLabel = UILabel()
  private let label = UILabel()

  init(icon: UIImage?, value: String, labelText: String) {
    super.init(frame: .zero)
    setupViews(icon: icon, value: value, labelText: labelText)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews(icon: UIImage?, value: String, labelText: String) {
    iconView.image = icon
    iconView.tintColor = .white
    iconView.contentMode = .scaleAspectFit
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.setContentHuggingPriority(.defaultHigh, for: .vertical)

    valueLabel.text = value
    valueLabel.font = .preferredFont(forTextStyle: .title2)
    valueLabel.textAlignment = .center
    valueLabel.textColor = .white

    label.text = labelText
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = UIColor.white.withAlphaComponent(0.7)
    label.textAlignment = .center

    let stack = UIStackView(arrangedSubviews: [iconView, valueLabel, label])
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

      iconView.heightAnchor.constraint(equalToConstant: 24),
      iconView.widthAnchor.constraint(equalToConstant: 24)
    ])
  }
}
