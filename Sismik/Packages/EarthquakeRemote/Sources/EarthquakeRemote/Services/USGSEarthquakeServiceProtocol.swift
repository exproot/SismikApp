//
//  USGSEarthquakeServiceProtocol.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine

public protocol USGSEarthquakeServiceProtocol {
  func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[USGSEarthquakeDTO], Error>
}
