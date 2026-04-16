//
//  USGSEarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import EarthquakeRemote

final class USGSEarthquakeRemoteDataSource: EarthquakeRemoteDataSource {
  
  private let service: USGSEarthquakeServiceProtocol
  
  init(service: USGSEarthquakeServiceProtocol) {
    self.service = service
  }
  
  func fetchRecentEarthquakes(request: EarthquakeRemote.EarthquakeRequest) -> AnyPublisher<[Earthquake], Error> {
    service.fetchRecentEarthquakes(request: request)
      .map { $0.map(USGSEarthquakeMapper.map) }
      .eraseToAnyPublisher()
  }
  
}
