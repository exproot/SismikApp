//
//  EMSCEarthquakeDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

struct EMSCEarthquakeDTO: Codable {
  let id: String
  let geometry: EMSCEarthquakeGeometryDTO
  let properties: EMSCEarthquakePropertiesDTO
}
