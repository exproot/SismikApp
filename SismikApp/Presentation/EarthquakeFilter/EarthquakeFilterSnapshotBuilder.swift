//
//  EarthquakeFilterSnapshotBuilder.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//


import UIKit

enum EarthquakeFilterSnapshotBuilder {
  static func build(from viewModel: DefaultEarthquakeFilterViewModel) -> NSDiffableDataSourceSnapshot<FilterSection, FilterItem> {
    let minSliderVM = SliderCellViewModel(
      title: NSLocalizedString("filter.minMagnitude", comment: ""),
      value: viewModel.minMagnitude,
      minValue: 0.0,
      maxValue: 10.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.minMagnitude = newVal
      })

    let maxSliderVM = SliderCellViewModel(
      title: NSLocalizedString("filter.maxMagnitude", comment: ""),
      value: viewModel.maxMagnitude,
      minValue: 0.0,
      maxValue: 10.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.maxMagnitude = newVal
      })

    let radiusSliderVM = SliderCellViewModel(
      title: NSLocalizedString("filter.searchRadius", comment: ""),
      value: viewModel.searchRadius,
      minValue: 100.0,
      maxValue: 1000.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.searchRadius = newVal
      })

    let startDateVM = DatePickerCellViewModel(
      title: NSLocalizedString("filter.startDate", comment: ""),
      date: viewModel.startDate,
      onChange: { [weak viewModel] date in
        viewModel?.startDate = date
      })

    let endDateVM = DatePickerCellViewModel(
      title: NSLocalizedString("filter.endDate", comment: ""),
      date: viewModel.endDate,
      onChange: { [weak viewModel] date in
        viewModel?.endDate = date
      })

    let actionsVM = ButtonGroupCellViewModel(buttons: [
      .init(title: NSLocalizedString("filter.button.reset", comment: ""), style: .destructive, action: { [weak viewModel] in
        viewModel?.resetToDefaults()
      }),
      .init(title: NSLocalizedString("filter.button.cancel", comment: ""), style: .cancel, action: { [weak viewModel] in
        viewModel?.onDismiss?()
      }),
      .init(title: NSLocalizedString("filter.button.apply", comment: ""), style: .default, action: { [weak viewModel] in
        viewModel?.applyFilter()
      })
    ])

    var snapshot = NSDiffableDataSourceSnapshot<FilterSection, FilterItem>()

    snapshot.appendSections([.magnitude, .timeRange, .actions])
    snapshot.appendItems([.slider(minSliderVM), .slider(maxSliderVM), .slider(radiusSliderVM)], toSection: .magnitude)
    snapshot.appendItems([.datePicker(startDateVM), .datePicker(endDateVM)], toSection: .timeRange)
    snapshot.appendItems([.buttonGroup(actionsVM)], toSection: .actions)

    return snapshot
  }
}
