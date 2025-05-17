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

  func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[EarthquakeFeatureDTO], Error> {

    guard let url = Endpoint.earthquakes(query: query).url else {
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
