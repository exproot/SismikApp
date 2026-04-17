//
//  EarthquakeEnriching.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import Combine

public protocol EarthquakeEnriching {
  func enrich(earthquakes: [Earthquake]) -> AnyPublisher<[EnrichedEarthquake], Never>
}
