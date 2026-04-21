//
//  EarthquakeFilterViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import EarthquakeDomain
import Foundation

struct EarthquakeFilterViewModelActions {
  let didSelectApply: (EarthquakeFilterOptions) -> Void
  let didSelectCancel: () -> Void
}

struct EarthquakeFilterOptions: Equatable {
  var minMagnitude: Double
  var maxMagnitude: Double
  var radiusKm: Double
  var startDate: Date
  var endDate: Date
  
  init(
    minMagnitude: Double,
    maxMagnitude: Double,
    radiusKm: Double,
    startDate: Date,
    endDate: Date
  ) {
    self.minMagnitude = minMagnitude
    self.maxMagnitude = maxMagnitude
    self.radiusKm = radiusKm
    self.startDate = startDate
    self.endDate = endDate
  }

  static var `default`: Self {
    Self(
      minMagnitude: 4.0,
      maxMagnitude: 10.0,
      radiusKm: 222.0,
      startDate: Calendar.current.date(byAdding: .day, value: -200, to: Date())!,
      endDate: Date()
    )
  }
}

enum FilterSection: Int, CaseIterable {
  case magnitude
  case timeRange
  case actions
}

enum FilterItem: Hashable, @unchecked Sendable {
  case slider(SliderCellViewModel)
  case datePicker(DatePickerCellViewModel)
  case buttonGroup(ButtonGroupCellViewModel)
}

final class EarthquakeFilterViewModel {

  private let actions: EarthquakeFilterViewModelActions
  
  var initialOptions: EarthquakeFilterOptions
  var onUIUpdate: (() -> Void)?

  init(
    actions: EarthquakeFilterViewModelActions,
    initialOptions: EarthquakeFilterOptions
  ) {
    self.actions = actions
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
    actions.didSelectApply(initialOptions)
    onUIUpdate?()
  }
  
  func cancelFilter() {
    actions.didSelectCancel()
  }

  func resetToDefaults() {
    initialOptions = .default
    onUIUpdate?()
  }
  
}
