//
//  MockEarthquakeService.swift
//  SismikAppTests
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation
@testable import SismikApp

final class MockEarthquakeService: EarthquakeServiceProtocol {

  var earthquakesToReturn: [EarthquakeFeatureDTO] = []
  var shouldFail = false

  func fetchRecentEarthquakes(
    minLatitude: Double? = nil,
    maxLatitude: Double? = nil,
    minLongitude: Double? = nil,
    maxLongitude: Double? = nil
  ) -> AnyPublisher<[EarthquakeFeatureDTO], Error> {
    if shouldFail {
      return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    } else {
      return Just(earthquakesToReturn)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
  }

}
