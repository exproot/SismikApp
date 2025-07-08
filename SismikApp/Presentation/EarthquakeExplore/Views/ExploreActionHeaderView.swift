//
//  ExploreActionHeaderView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import UIKit

final class ExploreActionHeaderView: UIView {
  let mapButton = UIButton(type: .system)
  let filterButton = UIButton(type: .system)

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupLayout() {
    mapButton.setTitle("Map", for: .normal)
    mapButton.setImage(UIImage(systemName: "map"), for: .normal)
    mapButton.tintColor = .systemBlue

    filterButton.setTitle("Filter", for: .normal)
    filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
    filterButton.tintColor = .systemBlue

    [mapButton, filterButton].forEach {
      $0.titleLabel?.font = .preferredFont(forTextStyle: .body)
      $0.contentHorizontalAlignment = .center
      $0.imageView?.contentMode = .scaleAspectFit
      $0.tintColor = .label
      $0.setTitleColor(.label, for: .normal)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let stack = UIStackView(arrangedSubviews: [mapButton, filterButton])
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
      stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    ])
  }
}
