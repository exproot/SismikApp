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
      title: "Min Magnitude",
      value: viewModel.minMagnitude,
      minValue: 0.0,
      maxValue: 10.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.minMagnitude = newVal
      })

    let maxSliderVM = SliderCellViewModel(
      title: "Max Magnitude",
      value: viewModel.maxMagnitude,
      minValue: 0.0,
      maxValue: 10.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.maxMagnitude = newVal
      })

    let radiusSliderVM = SliderCellViewModel(
      title: "Search Radius (km)",
      value: viewModel.searchRadius,
      minValue: 100.0,
      maxValue: 1000.0,
      onChange: { [weak viewModel] newVal in
        viewModel?.searchRadius = newVal
      })

    let startDateVM = DatePickerCellViewModel(
      title: "Start Date",
      date: viewModel.startDate,
      onChange: { [weak viewModel] date in
        viewModel?.startDate = date
      })

    let endDateVM = DatePickerCellViewModel(
      title: "End Date",
      date: viewModel.endDate,
      onChange: { [weak viewModel] date in
        viewModel?.endDate = date
      })

    let actionsVM = ButtonGroupCellViewModel(buttons: [
      .init(title: "Reset", style: .destructive, action: { [weak viewModel] in
        viewModel?.resetToDefaults()
      }),
      .init(title: "Cancel", style: .cancel, action: { [weak viewModel] in
        viewModel?.onDismiss?()
      }),
      .init(title: "Apply", style: .default, action: { [weak viewModel] in
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
