//
//  EMSCEarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import Combine
import EarthquakeDomain
import EarthquakeRemote

public final class EMSCEarthquakeRemoteDataSource: EarthquakeRemoteDataSource {
  
  private let service: EMSCEarthquakeServiceProtocol
  
  public init(service: EMSCEarthquakeServiceProtocol) {
    self.service = service
  }
  
  public func fetchRecentEarthquakes(request: EarthquakeRemote.EarthquakeRequest) -> AnyPublisher<[Earthquake], Error> {
    service.fetchRecentEarthquakes(request: request)
      .map { $0.map(EMSCEarthquakeMapper.map)}
      .eraseToAnyPublisher()
  }
  
}
