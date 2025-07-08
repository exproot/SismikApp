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
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.textAlignment = .center
    label.textColor = .secondaryLabel
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
    retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
    stack.axis = .vertical
    stack.spacing = 12
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32)
    ])
  }

  // MARK: Actions
  @objc private func didTapRetry() {
    retryAction?()
  }

}
