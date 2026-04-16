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
  private let enrichmentService: EarthquakeEnrichmentServiceProtocol

  init(
    repository: EarthquakeRepositoryProtocol,
    enrichmentService: EarthquakeEnrichmentServiceProtocol
  ) {
    self.repository = repository
    self.enrichmentService = enrichmentService
  }

}

// MARK: FetchNearbyEarthquakesUseCase
extension DefaultFetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol {

  func execute(query: EarthquakeQuery) -> AnyPublisher<[EnrichedEarthquake], Error> {
    repository.fetchRecentEarthquakes(query: query)
      .flatMap { [enrichmentService] earthquakes in
        enrichmentService.enrich(earthquakes: earthquakes)
      }
      .eraseToAnyPublisher()
  }

}
