//
//  AppDIContainer.swift
//  Sismik
//
//  Created by Ertan Yağmur on 17.04.2026.
//

import CoreNetworking
import LocationServices
import EarthquakeData
import EarthquakeDomain
import EarthquakeRemote
import EarthquakeSupport
import EartquakeDetailPresentation
import LocationAccessPresentation
import OnboardingPresentation
import DashboardPresentation
import ExplorePresentation
import MapPresentation

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
  
  func makeMapModule(with context: EarthquakeMapContext) -> MapModule {
    let dependencies = MapModuleDependencies(context: context)
    
    return MapModule(dependencies: dependencies)
  }
  
  func makeLocationAccessModule() -> LocationAccessModule {
    LocationAccessModule()
  }
  
  func makeOnboardingModule() -> OnboardingModule {
    OnboardingModule()
  }
  
  private func makeLocationStateController() -> LocationStateControlling {
    DefaultLocationStateController(locationManager: locationManager)
  }
  
}
