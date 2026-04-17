//
//  EarthquakeRemoteDataSource.swift
//  Sismik
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import EarthquakeDomain
import EarthquakeRemote

protocol EarthquakeRemoteDataSource {
  func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[Earthquake], Error>
}


