//
//  DefaultFetchNearbyEarthquakesUseCase.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import Combine
import Foundation

class DefaultFetchNearbyEarthquakesUseCase {

  private let repository: EarthquakeRepositoryProtocol

  init(repository: EarthquakeRepositoryProtocol) {
    self.repository = repository
  }

}

// MARK: FetchNearbyEarthquakesUseCase
extension DefaultFetchNearbyEarthquakesUseCase: FetchNearbyEarthquakesUseCaseProtocol {

  func execute(
    minLatitude: Double?,
    maxLatitude: Double?,
    minLongitude: Double?,
    maxLongitude: Double?
  ) -> AnyPublisher<[Earthquake], Error> {
    repository.fetchRecentEarthquakes(
      minLatitude: minLatitude,
      maxLatitude: maxLatitude,
      minLongitude: minLongitude,
      maxLongitude: maxLongitude
    )
  }

}
