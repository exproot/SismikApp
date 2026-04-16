//
//  EarthquakeRepositoryProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine

protocol EarthquakeRepositoryProtocol {
  func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[Earthquake], Error>
}
