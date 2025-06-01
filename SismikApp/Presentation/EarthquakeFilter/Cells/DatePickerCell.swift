//
//  DatePickerCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import UIKit

struct DatePickerCellViewModel: Hashable {
  let id = UUID()
  let title: String
  var date: Date
  let onChange: (Date) -> Void

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: DatePickerCellViewModel, rhs: DatePickerCellViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

final class DatePickerCell: UITableViewCell {

  static let reuseIdentifier = String(describing: DatePickerCell.self)

  private let titleLabel = UILabel()
  private let datePicker = UIDatePicker()

  private var onChange: ((Date) -> Void)?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with viewModel: DatePickerCellViewModel) {
    titleLabel.text = viewModel.title
    onChange = viewModel.onChange

    let calendar = Calendar(identifier: .gregorian)
    let minDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1))!
    let maxDate = Date()

    datePicker.minimumDate = minDate
    datePicker.maximumDate = maxDate

    let clampedDate = min(max(viewModel.date, minDate), maxDate)

    datePicker.date = clampedDate
  }

  private func setupUI() {
    titleLabel.textColor = .secondaryLabel
    titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
    datePicker.datePickerMode = .date

    let stack = UIStackView(arrangedSubviews: [titleLabel, datePicker])
    stack.axis = .horizontal
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])

    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }

  @objc private func dateChanged() {
    onChange?(datePicker.date)
  }
}
