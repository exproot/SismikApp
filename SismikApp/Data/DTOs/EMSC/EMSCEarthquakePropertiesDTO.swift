//
//  EMSCEarthquakePropertiesDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

struct EMSCEarthquakePropertiesDTO: Codable {
  let mag: Double
  let time: String
  let flynn_region: String
  let lat: Double
  let lon: Double
  let depth: Double
  let title: String?
}
