//
//  URLRequestBuilder.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct URLRequestBuilder: URLRequestBuilding {
  
  public init() {}
  
  public func build(from request: Requestable) throws -> URLRequest {
    guard var components = URLComponents(string: request.baseURL) else {
      throw NetworkError.invalidURL
    }
    
    components.path = request.path
    components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems
    
    guard let url = components.url else {
      throw NetworkError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    
    request.headers.forEach { key, value in
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }
    
    return urlRequest
  }
  
}
