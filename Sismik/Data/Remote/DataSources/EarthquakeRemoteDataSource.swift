//
//  EarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import EarthquakeRemote

protocol EarthquakeRemoteDataSource {
  func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[Earthquake], Error>
}

final class EMSCEarthquakeRemoteDataSource: EarthquakeRemoteDataSource {
  
  private let service: EMSCEarthquakeServiceProtocol
  
  init(service: EMSCEarthquakeServiceProtocol) {
    self.service = service
  }
  
  func fetchRecentEarthquakes(request: EarthquakeRemote.EarthquakeRequest) -> AnyPublisher<[Earthquake], Error> {
    service.fetchRecentEarthquakes(request: request)
      .map { $0.map(EMSCEarthquakeMapper.map)}
      .eraseToAnyPublisher()
  }
  
}
