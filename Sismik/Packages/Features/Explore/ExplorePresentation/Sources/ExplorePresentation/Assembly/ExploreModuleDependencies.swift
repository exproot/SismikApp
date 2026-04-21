//
//  ExploreModuleDependencies.swift
//  ExplorePresentation
//
//  Created by Ertan Yağmur on 19.04.2026.
//

import EarthquakeDomain
import EarthquakeSupport
import LocationServices

public struct ExploreModuleDependencies {
  
  public let earthquakeRepository: EarthquakeRepositoryProtocol
  public let enricher: EarthquakeEnriching
  public let geocoder: GeocodingServiceProtocol
  public let queryStore: EarthquakeQueryStore
  
  public init(
    earthquakeRepository: EarthquakeRepositoryProtocol,
    enricher: EarthquakeEnriching,
    geocoder: GeocodingServiceProtocol,
    queryStore: EarthquakeQueryStore
  ) {
    self.earthquakeRepository = earthquakeRepository
    self.enricher = enricher
    self.geocoder = geocoder
    self.queryStore = queryStore
  }
  
}
