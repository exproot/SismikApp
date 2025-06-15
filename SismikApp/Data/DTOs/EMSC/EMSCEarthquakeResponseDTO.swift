//
//  EMSCEarthquakeResponseDTO.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

struct EMSCEarthquakeResponseDTO: Codable {
  let features: [EMSCEarthquakeDTO]
}
