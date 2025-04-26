//
//  EarthquakeFeatureDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//

import Foundation

struct EarthquakeFeatureDTO: Codable {
  let id: String
  let properties: EarthquakePropertiesDTO
  let geometry: EarthquakeGeometryDTO
}
