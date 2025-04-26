//
//  FetchNearbyEarthquakesUseCaseProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

protocol FetchNearbyEarthquakesUseCaseProtocol {
  func execute(
    minLatitude: Double?,
    maxLatitude: Double?,
    minLongitude: Double?,
    maxLongitude: Double?
  ) -> AnyPublisher<[Earthquake], Error>
}
