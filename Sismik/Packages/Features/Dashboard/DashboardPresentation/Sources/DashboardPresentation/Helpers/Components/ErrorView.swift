//
//  ErrorView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class ErrorView: UIView {

  private var retryAction: (() -> Void)?

  // MARK: UI Components
  private let imageView: UIImageView = {
    let image = UIImage(systemName: "xmark.circle")
    let view = UIImageView(image: image)
    view.tintColor = .systemRed
    view.contentMode = .scaleAspectFit
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let messageLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let retryButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle(NSLocalizedString("explore.error.retry", comment: ""), for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .body)
    return button
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func updateMessage(_ message: String?) {
    messageLabel.text = message
  }

  func setRetryAction(_ action: @escaping () -> Void) {
    retryAction = action
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

    let stack = UIStackView(arrangedSubviews: [imageContainer, messageLabel, retryButton])
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

    retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
  }

  // MARK: Actions
  @objc private func didTapRetry() {
    retryAction?()
  }

}
