//
//  USGSEarthquakeService.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

class USGSEarthquakeService: EarthquakeServiceProtocol {

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func fetchRecentEarthquakes(
    minLatitude: Double? = nil,
    maxLatitude: Double? = nil,
    minLongitude: Double? = nil,
    maxLongitude: Double? = nil
  ) -> AnyPublisher<[EarthquakeFeatureDTO], Error> {

    guard let url = Endpoint.earthquakes(
      minLatitude: minLatitude,
      maxLatitude: maxLatitude,
      minLongitude: minLongitude,
      maxLongitude: maxLongitude
    ).url else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: EarthquakeResponseDTO.self, decoder: JSONDecoder())
      .map { $0.features }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

}
