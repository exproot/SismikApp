//
//  EarthquakeServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

protocol EarthquakeServiceProtocol {
  func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[EarthquakeDTOConvertible], Error>
}
