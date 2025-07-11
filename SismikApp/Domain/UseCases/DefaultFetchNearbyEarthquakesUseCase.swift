//
//  DefaultFetchNearbyEarthquakesUseCase.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

final class DefaultFetchNearbyEarthquakesUseCase {

  private let repository: EarthquakeRepositoryProtocol

  init(repository: EarthquakeRepositoryProtocol) {
    self.repository = repository
  }

}

// MARK: FetchNearbyEarthquakesUseCase
extension DefaultFetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol {

  func execute(query: EarthquakeQuery) -> AnyPublisher<[Earthquake], Error> {
    repository.fetchRecentEarthquakes(query: query)
  }

}
