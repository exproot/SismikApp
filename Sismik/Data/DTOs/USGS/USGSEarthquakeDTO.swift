//
//  USGSEarthquakeDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//

import Foundation

struct USGSEarthquakeDTO: Codable {
  let id: String
  let properties: USGSEarthquakePropertiesDTO
  let geometry: USGSEarthquakeGeometryDTO
}
