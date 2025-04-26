//
//  EarthquakeServiceProtocol.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import Combine
import Foundation

protocol EarthquakeServiceProtocol {
  func fetchRecentEarthquakes(
    minLatitude: Double?,
    maxLatitude: Double?,
    minLongitude: Double?,
    maxLongitude: Double?
  ) -> AnyPublisher<[EarthquakeFeatureDTO], Error>
}
