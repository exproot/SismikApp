//
//  USGSEarthquakeDTO.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public struct USGSEarthquakeDTO: Codable, Sendable {
  public let id: String
  public let properties: USGSEarthquakePropertiesDTO
  public let geometry: USGSEarthquakeGeometryDTO
  
  public init(
    id: String,
    properties: USGSEarthquakePropertiesDTO,
    geometry: USGSEarthquakeGeometryDTO
  ) {
    self.id = id
    self.properties = properties
    self.geometry = geometry
  }
}


public struct USGSEarthquakeGeometryDTO: Codable, Sendable {
  public let coordinates: [Double]
  
  public init(coordinates: [Double]) {
    self.coordinates = coordinates
  }
}

public struct USGSEarthquakePropertiesDTO: Codable, Sendable {
  public let mag: Double?
  public let place: String
  public let time: Int64
  public let url: String
  public let title: String
  
  public init(
    mag: Double?,
    place: String,
    time: Int64,
    url: String,
    title: String
  ) {
    self.mag = mag
    self.place = place
    self.time = time
    self.url = url
    self.title = title
  }
}

public struct USGSEarthquakeResponseDTO: Codable, Sendable {
  public let features: [USGSEarthquakeDTO]
  
  public init(features: [USGSEarthquakeDTO]) {
    self.features = features
  }
}

