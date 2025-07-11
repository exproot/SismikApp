//
//  DefaultEarthquakeFilterViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import Foundation

enum FilterSection: Int, CaseIterable {
  case magnitude
  case timeRange
  case actions
}

enum FilterItem: Hashable {
  case slider(SliderCellViewModel)
  case datePicker(DatePickerCellViewModel)
  case buttonGroup(ButtonGroupCellViewModel)
}

protocol EarthquakeFilterViewModelInput {
  func applyFilter()
  func resetToDefaults()
}

protocol EarthquakeFilterViewModelOutput {
  var onUIUpdate: (() -> Void)? { get set }
  var onApply: ((EarthquakeFilterOptions) -> Void)? { get set }
  var onDismiss: (() -> Void)? { get set }
}

typealias EarthquakeFilterViewModelType = EarthquakeFilterViewModelInput & EarthquakeFilterViewModelOutput

final class DefaultEarthquakeFilterViewModel: EarthquakeFilterViewModelType {

  var initialOptions: EarthquakeFilterOptions

  var onUIUpdate: (() -> Void)?
  var onApply: ((EarthquakeFilterOptions) -> Void)?
  var onDismiss: (() -> Void)?

  init(initialOptions: EarthquakeFilterOptions) {
    self.initialOptions = initialOptions
  }

  var minMagnitude: Double {
    get { initialOptions.minMagnitude }
    set { initialOptions.minMagnitude = newValue }
  }

  var maxMagnitude: Double {
    get { initialOptions.maxMagnitude }
    set { initialOptions.maxMagnitude = newValue }
  }

  var searchRadius: Double {
    get { initialOptions.radiusKm }
    set { initialOptions.radiusKm = newValue }
  }

  var startDate: Date {
    get { initialOptions.startDate }
    set { initialOptions.startDate = newValue }
  }

  var endDate: Date {
    get { initialOptions.endDate }
    set { initialOptions.endDate = newValue }
  }

  func applyFilter() {
    onApply?(initialOptions)
    onDismiss?()
  }

  func resetToDefaults() {
    initialOptions = .default
    onUIUpdate?()
  }
  
}
