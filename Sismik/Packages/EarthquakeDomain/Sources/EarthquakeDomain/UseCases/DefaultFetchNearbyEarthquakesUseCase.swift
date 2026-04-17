//
//  DefaultFetchNearbyEarthquakesUseCase.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

public final class DefaultFetchNearbyEarthquakesUseCase {

  private let repository: EarthquakeRepositoryProtocol
  private let enrichmentService: EarthquakeEnriching

  public init(
    repository: EarthquakeRepositoryProtocol,
    enrichmentService: EarthquakeEnriching
  ) {
    self.repository = repository
    self.enrichmentService = enrichmentService
  }

}

// MARK: FetchNearbyEarthquakesUseCase
extension DefaultFetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol {

  public func execute(query: EarthquakeQuery) -> AnyPublisher<[EnrichedEarthquake], Error> {
    repository.fetchRecentEarthquakes(query: query)
      .flatMap { [enrichmentService] earthquakes in
        enrichmentService.enrich(earthquakes: earthquakes)
      }
      .eraseToAnyPublisher()
  }

}
