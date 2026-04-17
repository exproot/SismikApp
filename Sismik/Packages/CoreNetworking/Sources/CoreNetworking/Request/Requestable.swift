//
//  Requestable.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public protocol Requestable {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var queryItems: [URLQueryItem] { get }
}
