//
//  EarthquakeResponseDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import Foundation

struct EarthquakeResponseDTO: Codable {
  let features: [EarthquakeFeatureDTO]
}
