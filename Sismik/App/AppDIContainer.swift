//
//  AppDIContainer.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import CoreNetworking
import DashboardPresentation
import EarthquakeData
import EarthquakeDomain
import EarthquakeRemote
import LocationServices

@MainActor
final class AppDIContainer {
  
  lazy var httpClient: HTTPClient = URLSessionHTTPClient()
  lazy var usgsEarthquakeService: USGSEarthquakeServiceProtocol = USGSEarthquakeService(client: httpClient)
  lazy var earthquakeRemoteSource: EarthquakeRemoteDataSource = USGSEarthquakeRemoteDataSource(service: usgsEarthquakeService)
  lazy var earthquakeRepository: EarthquakeRepositoryProtocol = DefaultEarthquakeRepository(remoteDataSource: earthquakeRemoteSource)
  lazy var geocodingService: GeocodingServiceProtocol = DefaultGeocodingService()
  lazy var earthquakeEnricher: EarthquakeEnriching = DefaultEarthquakeEnricher(geocoder: geocodingService)
  lazy var locationManager: LocationManagerProtocol = DefaultLocationManager()
  
  func makeLocationStateController() -> LocationStateControlling {
    DefaultLocationStateController(locationManager: locationManager)
  }
  
  func makeDashboardModule() -> DashboardModule {
    let dependencies =  DashboardModuleDependencies(
      earthquakeRepository: earthquakeRepository,
      enricher: earthquakeEnricher,
      makeLocationStateController: { [weak self] in
        guard let self else {
          return DefaultLocationStateController(locationManager: DefaultLocationManager())
        }
        
        return self.makeLocationStateController()
      }
    )
    
    return DashboardModule(dependencies: dependencies)
  }
  
}
