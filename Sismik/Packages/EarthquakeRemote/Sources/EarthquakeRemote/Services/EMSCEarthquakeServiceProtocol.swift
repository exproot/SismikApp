//
//  EMSCEarthquakeServiceProtocol.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine

public protocol EMSCEarthquakeServiceProtocol {
  func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[EMSCEarthquakeDTO], Error>
}
