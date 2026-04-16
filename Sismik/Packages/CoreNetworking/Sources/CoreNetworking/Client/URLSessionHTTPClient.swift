//
//  URLSessionHTTPClient.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import Foundation

public final class URLSessionHTTPClient: HTTPClient {
  
  private let session: URLSession
  private let decoder: JSONDecoder
  
  public init(
    session: URLSession = .shared,
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.session = session
    self.decoder = decoder
  }
  
  public func execute<T: Decodable>(
    _ request: URLRequest,
    repsonseType: T.Type
  ) -> AnyPublisher<T, Error> {
    session.dataTaskPublisher(for: request)
      .tryMap { output in
        guard let response = output.response as? HTTPURLResponse else {
          throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= response.statusCode else {
          throw NetworkError.httpStatusCode(response.statusCode)
        }
        
        return output.data
      }
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        if let networkError = error as? NetworkError {
          return networkError
        } else if error is DecodingError {
          return NetworkError.decodingFailed(error)
        } else {
          return NetworkError.underlying(error)
        }
      }
      .eraseToAnyPublisher()
  }
  
  
}
