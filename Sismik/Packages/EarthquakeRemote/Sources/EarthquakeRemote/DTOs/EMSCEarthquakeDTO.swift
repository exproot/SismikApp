//
//  EMSCEarthquakeDTO.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct EMSCEarthquakeDTO: Codable, Sendable {
  public let id: String
  public let geometry: EMSCEarthquakeGeometryDTO
  public let properties: EMSCEarthquakePropertiesDTO
  
  public init(
    id: String,
    geometry: EMSCEarthquakeGeometryDTO,
    properties: EMSCEarthquakePropertiesDTO
  ) {
    self.id = id
    self.geometry = geometry
    self.properties = properties
  }
}

public struct EMSCEarthquakeGeometryDTO: Codable, Sendable {
  public let coordinates: [Double]
  
  public init(coordinates: [Double]) {
    self.coordinates = coordinates
  }
}

public struct EMSCEarthquakePropertiesDTO: Codable, Sendable {
  public let mag: Double
  public let time: String
  public let flynn_region: String
  public let lat: Double
  public let lon: Double
  public let depth: Double
  public let title: String?
  
  public init(
    mag: Double,
    time: String,
    flynn_region: String,
    lat: Double,
    lon: Double,
    depth: Double,
    title: String?
  ) {
    self.mag = mag
    self.time = time
    self.flynn_region = flynn_region
    self.lat = lat
    self.lon = lon
    self.depth = depth
    self.title = title
  }
}

public struct EMSCEarthquakeResponseDTO: Codable, Sendable {
  public let features: [EMSCEarthquakeDTO]
  
  public init(features: [EMSCEarthquakeDTO]) {
    self.features = features
  }
}

