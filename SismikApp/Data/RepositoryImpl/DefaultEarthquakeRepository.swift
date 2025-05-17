//
//  DefaultEarthquakeRepository.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine

final class DefaultEarthquakeRepository {

  private let service: EarthquakeServiceProtocol

  init(service: EarthquakeServiceProtocol) {
    self.service = service
  }

}

// MARK: EarthquakeRepositoryProtocol
extension DefaultEarthquakeRepository: EarthquakeRepositoryProtocol {

  func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[Earthquake], Error> {
    return service.fetchRecentEarthquakes(query: query)
      .compactMap { features in
        features.compactMap { $0.mapToDomain() }
      }
      .eraseToAnyPublisher()
  }

}
