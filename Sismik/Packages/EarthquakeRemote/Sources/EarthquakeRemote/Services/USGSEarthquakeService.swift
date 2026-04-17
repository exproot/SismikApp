//
//  USGSEarthquakeService.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Combine
import CoreNetworking

public final class USGSEarthquakeService: USGSEarthquakeServiceProtocol {
  
  private let client: HTTPClient
  private let requestBuilder: URLRequestBuilding
  private let queryItemBuilder: QueryItemBuilding
  
  public init(
    client: HTTPClient,
    requestBuilder: URLRequestBuilding = URLRequestBuilder(),
    queryItemBuilder: QueryItemBuilding = USGSQueryItemBuilder()
  ) {
    self.client = client
    self.requestBuilder = requestBuilder
    self.queryItemBuilder = queryItemBuilder
  }
  
  public func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[USGSEarthquakeDTO], Error> {
    let queryItems = queryItemBuilder.build(from: request)
    let endpoint = USGSEarthquakeRequest(queryItems: queryItems)
    
    do {
      let urlRequest = try requestBuilder.build(from: endpoint)
      
      return client.execute(urlRequest, repsonseType: USGSEarthquakeResponseDTO.self)
        .map(\.features)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
  
}
