//
//  Coordinate.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 11.07.2025.
//

import CoreLocation
import Foundation

public struct Coordinate: Hashable {
  public let latitude: Double
  public let longitude: Double

  public init(_ coordinate: CLLocationCoordinate2D) {
    latitude = coordinate.latitude
    longitude = coordinate.longitude
  }

  public var clLocationCoordinate2D: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(latitude)
    hasher.combine(longitude)
  }

  public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}
