//
//  EMSCEarthquakeService.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import CoreNetworking
import Combine

public final class EMSCEarthquakeService: EMSCEarthquakeServiceProtocol {
  
  private let client: HTTPClient
  private let requestBuilder: URLRequestBuilding
  private let queryItemBuilder: QueryItemBuilding
  
  public init(
    client: HTTPClient,
    requestBuilder: URLRequestBuilding = URLRequestBuilder(),
    queryItemBuilder: QueryItemBuilding = EMSCQueryItemBuilder()
  ) {
    self.client = client
    self.requestBuilder = requestBuilder
    self.queryItemBuilder = queryItemBuilder
  }
  
  public func fetchRecentEarthquakes(request: EarthquakeRequest) -> AnyPublisher<[EMSCEarthquakeDTO], Error> {
    let queryItems = queryItemBuilder.build(from: request)
    let endpoint = EMSCEarthquakeRequest(queryItems: queryItems)
    
    do {
      let urlRequest = try requestBuilder.build(from: endpoint)
      
      return client.execute(urlRequest, repsonseType: EMSCEarthquakeResponseDTO.self)
        .map(\.features)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
  
}
