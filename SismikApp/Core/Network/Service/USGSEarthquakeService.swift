//
//  USGSEarthquakeService.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import Combine
import Foundation

final class USGSEarthquakeService: EarthquakeServiceProtocol {

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func fetchRecentEarthquakes(query: EarthquakeQuery) -> AnyPublisher<[EarthquakeDTOConvertible], Error> {

    guard let url = Endpoint.usgsEarthquakes(query: query).url else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }

    return session.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: USGSEarthquakeResponseDTO.self, decoder: JSONDecoder())
      .map { $0.features as [EarthquakeDTOConvertible] }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

}
