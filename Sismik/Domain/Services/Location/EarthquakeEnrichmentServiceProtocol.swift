//
//  EarthquakeEnrichmentServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import Combine
import CoreLocation
import Foundation

protocol EarthquakeEnrichmentServiceProtocol {
  func enrich(earthquakes: [Earthquake]) -> AnyPublisher<[EnrichedEarthquake], Never>
}
