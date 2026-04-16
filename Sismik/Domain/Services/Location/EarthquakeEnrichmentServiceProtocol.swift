//
//  EarthquakeEnrichmentServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import Combine

protocol EarthquakeEnrichmentServiceProtocol {
  func enrich(earthquakes: [Earthquake]) -> AnyPublisher<[EnrichedEarthquake], Never>
}
