//
//  HTTPClient.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import Foundation

public protocol HTTPClient {
  func execute<T: Decodable>(
    _ request: URLRequest,
    repsonseType: T.Type
  ) -> AnyPublisher<T, Error>
}
