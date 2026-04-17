//
//  DefaultEarthquakeRepository.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import EarthquakeDomain
import EarthquakeRemote

public final class DefaultEarthquakeRepository {
  
  private let remoteDataSource: EarthquakeRemoteDataSource
  
  public init(remoteDataSource: EarthquakeRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

}

// MARK: EarthquakeRepositoryProtocol
extension DefaultEarthquakeRepository: EarthquakeRepositoryProtocol {
  
  public func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[Earthquake], Error> {
    let request = EarthquakeRequest(query: query)
    
    return remoteDataSource.fetchRecentEarthquakes(request: request)
      .eraseToAnyPublisher()
  }

}
