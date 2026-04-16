//
//  SliderCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import UIKit

struct SliderCellViewModel: Hashable {
  let id = UUID()
  let title: String
  var value: Double
  let minValue: Double
  let maxValue: Double
  let onChange: (Double) -> Void

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: SliderCellViewModel, rhs: SliderCellViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

final class SliderCell: UITableViewCell {

  static let reuseIdentifier = String(describing: SliderCell.self)

  private let titleLabel = UILabel()
  private let valueLabel = UILabel()
  private let slider = UISlider()

  private var onChange: ((Double) -> Void)?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with viewModel: SliderCellViewModel) {
    titleLabel.text = viewModel.title
    valueLabel.text = String(format: "%.1f", viewModel.value)
    slider.minimumValue = Float(viewModel.minValue)
    slider.maximumValue = Float(viewModel.maxValue)
    slider.value = Float(viewModel.value)
    onChange = viewModel.onChange
  }

  func setupUI() {
    titleLabel.textColor = .secondaryLabel
    valueLabel.textColor = .label

    let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, slider])

    stack.axis = .vertical
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])

    slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
  }

  // MARK: Selectors
  @objc private func sliderChanged() {
    valueLabel.text = String(format: "%.1f", slider.value)
    onChange?(Double(slider.value))
  }

}
