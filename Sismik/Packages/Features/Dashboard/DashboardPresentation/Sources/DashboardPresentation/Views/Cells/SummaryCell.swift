//
//  SummaryCell.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class SummaryCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: SummaryCell.self)

  private let stackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.sublayers?.first?.frame = contentView.bounds

    layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: contentView.layer.cornerRadius
    ).cgPath
  }

  func configure(with item: EarthquakeDashboardSummaryItem) {
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    let total = StatView(
      icon: UIImage(systemName: "globe"),
      value: "\(item.totalCount)",
      labelText: NSLocalizedString("dashboard.section.summary.total", comment: "")
    )
    let avgMag = StatView(
      icon: UIImage(systemName: "waveform.path.ecg"),
      value: String(format: "%.1f", item.averageMagnitude),
      labelText: NSLocalizedString("dashboard.section.summary.average", comment: "")
    )
    let maxDepth = StatView(
      icon: UIImage(systemName: "arrow.down.to.line"),
      value: String(format: "%.0f km", item.maxDepth),
      labelText: NSLocalizedString("dashboard.section.summary.max.depth", comment: "")
    )

    [total, avgMag, maxDepth].forEach { view in
      view.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(view)
    }
  }

  private func setupLayout() {
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])

    let gradient = CAGradientLayer()
    gradient.colors = [
      UIColor(named: "SecondaryAccent")!.cgColor,
      UIColor(named: "AccentColor")!.cgColor
    ]
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    gradient.cornerRadius = 16
    gradient.masksToBounds = true
    contentView.layer.insertSublayer(gradient, at: 0)

    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 2)
  }

}
