//
//  FetchNearbyEarthquakesUseCaseProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine

public protocol FetchNearbyEarthquakesUseCaseProtocol {
  func execute(query: EarthquakeQuery) -> AnyPublisher<[EnrichedEarthquake], Error>
}
