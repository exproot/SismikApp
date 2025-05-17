//
//  ButtonGroupCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import UIKit

struct ButtonGroupCellViewModel: Hashable {
  let id = UUID()
  let buttons: [ButtonItem]

  struct ButtonItem: Hashable {
    let title: String
    let style: ButtonStyle
    let action: () -> Void

    enum ButtonStyle: Hashable {
      case `default`, cancel, destructive
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(title)
    }

    static func == (lhs: ButtonItem, rhs: ButtonItem) -> Bool {
      lhs.title == rhs.title
    }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: ButtonGroupCellViewModel, rhs: ButtonGroupCellViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

final class ButtonGroupCell: UITableViewCell {

  static let reuseIdentifier = String(describing: ButtonGroupCell.self)

  private let stack = UIStackView()
  private var actions: [() -> Void] = []

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with viewModel: ButtonGroupCellViewModel) {
    stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    actions = []

    for (index, item) in viewModel.buttons.enumerated() {
      let button = UIButton(type: .system)

      button.setTitle(item.title, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

      switch item.style {
      case .default:
        button.setTitleColor(.systemBlue, for: .normal)
      case .cancel:
        button.setTitleColor(.systemRed, for: .normal)
      case .destructive:
        button.setTitleColor(.secondaryLabel, for: .normal)
      }

      button.tag = index
      button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
      stack.addArrangedSubview(button)
      actions.append(item.action)
    }
  }

  private func setupUI() {
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  // MARK: Selectors
  @objc private func buttonTapped(_ sender: UIButton) {
    let index = sender.tag
    guard index < actions.count else { return }

    actions[index]()
  }
}
