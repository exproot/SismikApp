//
//  MockEarthquakeRepository.swift
//  SismikAppTests
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
@testable import SismikApp

final class MockEarthquakeRepository: EarthquakeRepositoryProtocol {

  var resultToReturn: Result<[Earthquake], Error> = .success([])

  func fetchRecentEarthquakes(
    minLatitude: Double?,
    maxLatitude: Double?,
    minLongitude: Double?,
    maxLongitude: Double?
  ) -> AnyPublisher<[Earthquake], Error> {
    switch resultToReturn {
    case .success(let earthquakes):
      return Just(earthquakes)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    case .failure(let error):
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
  }

}
