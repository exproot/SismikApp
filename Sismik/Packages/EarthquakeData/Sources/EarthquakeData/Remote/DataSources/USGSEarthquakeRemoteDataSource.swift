//
//  USGSEarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import EarthquakeDomain
import EarthquakeRemote

public final class USGSEarthquakeRemoteDataSource: EarthquakeRemoteDataSource {
  
  private let service: USGSEarthquakeServiceProtocol
  
  public init(service: USGSEarthquakeServiceProtocol) {
    self.service = service
  }
  
  public func fetchRecentEarthquakes(request: EarthquakeRemote.EarthquakeRequest) -> AnyPublisher<[Earthquake], Error> {
    service.fetchRecentEarthquakes(request: request)
      .map { $0.map(USGSEarthquakeMapper.map) }
      .eraseToAnyPublisher()
  }
  
}
