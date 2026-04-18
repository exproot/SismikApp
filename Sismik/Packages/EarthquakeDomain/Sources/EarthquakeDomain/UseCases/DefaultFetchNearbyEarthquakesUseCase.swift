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
  private let enricher: EarthquakeEnriching

  public init(
    repository: EarthquakeRepositoryProtocol,
    enricher: EarthquakeEnriching
  ) {
    self.repository = repository
    self.enricher = enricher
  }

}

// MARK: FetchNearbyEarthquakesUseCase
extension DefaultFetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol {

  public func execute(query: EarthquakeQuery) -> AnyPublisher<[EnrichedEarthquake], Error> {
    repository.fetchRecentEarthquakes(query: query)
      .flatMap { [enricher] earthquakes in
        enricher.enrich(earthquakes: earthquakes)
      }
      .eraseToAnyPublisher()
  }

}
