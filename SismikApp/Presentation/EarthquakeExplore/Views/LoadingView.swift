//
//  LoadingView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class LoadingView: UIView {

  // MARK: UI Components
  private let activityIndicator = UIActivityIndicatorView(style: .medium)
  private let loadingLabel: UILabel = {
    let label = UILabel()
    label.text = NSLocalizedString("explore.loading", comment: "")
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = .secondaryLabel
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
    activityIndicator.startAnimating()

    let stack = UIStackView(arrangedSubviews: [activityIndicator, loadingLabel])
    stack.axis = .vertical
    stack.spacing = 8
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)

    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

}
