//
//  EMSCEarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import Combine
import EarthquakeDomain
import EarthquakeRemote

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
