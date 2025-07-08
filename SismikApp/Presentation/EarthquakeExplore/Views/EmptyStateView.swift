//
//  EmptyStateView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class EmptyStateView: UIView {

  // MARK: UI Components
  private let imageView: UIImageView = {
    let image = UIImage(systemName: "globe.desk.fill")
    let view = UIImageView(image: image)
    view.tintColor = .systemOrange
    view.contentMode = .scaleAspectFit
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("explore.emptyState.title", comment: "")
    label.font = .preferredFont(forTextStyle: .title2)
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("explore.emptyState.desc", comment: "")
    label.font = .preferredFont(forTextStyle: .body)
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup
  private func setupViews() {

    let imageContainer = UIView()

    imageContainer.translatesAutoresizingMaskIntoConstraints = false
    imageContainer.addSubview(imageView)

    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.heightAnchor.constraint(equalToConstant: 80)
    ])

    let stack = UIStackView(arrangedSubviews: [imageContainer, titleLabel, descriptionLabel])
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)

    NSLayoutConstraint.activate([
      imageContainer.heightAnchor.constraint(equalToConstant: 100),

      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32)
    ])
  }

}
