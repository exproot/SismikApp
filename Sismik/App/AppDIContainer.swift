//
//  AppDIContainer.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import CoreNetworking
import DashboardPresentation
import EarthquakeData
import EartquakeDetailPresentation
import EarthquakeDomain
import EarthquakeRemote
import EarthquakeSupport
import ExplorePresentation
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
  lazy var queryStore: EarthquakeQueryStore = UserDefaultsEarthquakeQueryStore()
  
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
  
  func makeExploreModule() -> ExploreModule {
    let dependencies = ExploreModuleDependencies(
      earthquakeRepository: earthquakeRepository,
      enricher: earthquakeEnricher,
      geocoder: geocodingService,
      queryStore: queryStore
    )
    
    return ExploreModule(dependencies: dependencies)
  }
  
  func makeEarthquakeDetailModule(with context: EarthquakeDetailContext) -> EarthquakeDetailModule {
    let dependencies = EarthquakeDetailModuleDependencies(context: context)
    
    return EarthquakeDetailModule(dependencies: dependencies)
  }
  
  private func makeLocationStateController() -> LocationStateControlling {
    DefaultLocationStateController(locationManager: locationManager)
  }
  
}
