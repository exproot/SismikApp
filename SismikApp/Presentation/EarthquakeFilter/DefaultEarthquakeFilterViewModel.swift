//
//  DefaultEarthquakeFilterViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import CoreLocation
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
  var minMagnitude: Double { get set }
  var maxMagnitude: Double { get set }
  var startDate: Date { get set }
  var endDate: Date { get set }

  var onUIUpdate: (() -> Void)? { get set }
  var onApply: ((EarthquakeQuery) -> Void)? { get set }
  var onDismiss: (() -> Void)? { get set }
}

typealias EarthquakeFilterViewModelType = EarthquakeFilterViewModelInput & EarthquakeFilterViewModelOutput

final class DefaultEarthquakeFilterViewModel: EarthquakeFilterViewModelType {

  var minMagnitude: Double
  var maxMagnitude: Double
  var startDate: Date
  var endDate: Date

  var onUIUpdate: (() -> Void)?
  var onApply: ((EarthquakeQuery) -> Void)?
  var onDismiss: (() -> Void)?

  // MARK: State
  private let baseCoordinate: CLLocationCoordinate2D

  init(initialQuery: EarthquakeQuery, coordinate: CLLocationCoordinate2D) {
    self.minMagnitude = initialQuery.minMagnitude ?? 4.0
    self.maxMagnitude = initialQuery.maxMagnitude ?? 10.0
    self.startDate = initialQuery.startTime ?? Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    self.endDate = initialQuery.endTime ?? Date()
    self.baseCoordinate = coordinate
  }

  func applyFilter() {
    let query = EarthquakeQuery(
      minLatitude: baseCoordinate.latitude - 2,
      maxLatitude: baseCoordinate.latitude + 2,
      minLongitude: baseCoordinate.longitude - 2,
      maxLongitude: baseCoordinate.longitude + 2,
      minMagnitude: minMagnitude,
      maxMagnitude: maxMagnitude,
      startTime: startDate,
      endTime: endDate
    )

    onApply?(query)
    onDismiss?()
  }

  func resetToDefaults() {
    minMagnitude = 4.0
    maxMagnitude = 10.0
    startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    endDate = Date()

    onUIUpdate?()
  }
  
}
