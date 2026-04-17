//
//  Earthquake.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//


import Foundation

public struct Earthquake: Identifiable, Equatable, Hashable, Sendable {
  public let id: String
  public let title: String
  public let magnitude: Double
  public let place: String
  public let time: Date
  public let latitude: Double
  public let longitude: Double
  public let depth: Double
  
  public init(
    id: String,
    title: String,
    magnitude: Double,
    place: String,
    time: Date,
    latitude: Double,
    longitude: Double,
    depth: Double
  ) {
    self.id = id
    self.title = title
    self.magnitude = magnitude
    self.place = place
    self.time = time
    self.latitude = latitude
    self.longitude = longitude
    self.depth = depth
  }

  public static let sampleEarthquake = Earthquake(
    id: "0",
    title: "M 4.3 - 19 km S of Mock, Place",
    magnitude: 4.3,
    place: "35 km S of Mock, Place",
    time: Date(),
    latitude: 28.4496,
    longitude: 40.8476,
    depth: 13.696
  )
}

public struct EnrichedEarthquake: Hashable, Sendable {
  public let earthquake: Earthquake
  public let locationName: String
  
  public init(earthquake: Earthquake, locationName: String) {
    self.earthquake = earthquake
    self.locationName = locationName
  }
}
