//
//  ExploreViewModeHeaderView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 9.07.2025.
//

import UIKit

final class ExploreViewModeHeaderView: UITableViewHeaderFooterView {

  static let reuseIdentifier = String(describing: ExploreViewModeHeaderView.self)

  let segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: [
      NSLocalizedString("explore.segmented.list", comment: "List"),
      NSLocalizedString("explore.segmented.map", comment: "Map")
    ])

    control.selectedSegmentIndex = 0
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    segmentedControl.selectedSegmentTintColor = UIColor(named: "AccentColor")

    let normalTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.secondaryLabel
    ]

    let selectedTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white
    ]

    segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
    segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    segmentedControl.layer.cornerRadius = 8
    segmentedControl.clipsToBounds = true

    addSubview(segmentedControl)

    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}
