//
//  QueryItemBuilding.swift
//  EarthquakeRemote
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public protocol QueryItemBuilding {
  func build(from request: EarthquakeRequest) -> [URLQueryItem]
}
