//
//  NetworkError.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case httpStatusCode(Int)
  case emptyData
  case decodingFailed(Error)
  case underlying(Error)
}
