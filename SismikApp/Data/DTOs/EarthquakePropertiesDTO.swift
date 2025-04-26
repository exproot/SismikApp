//
//  Properties.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import Foundation

struct EarthquakePropertiesDTO: Codable {
  let mag: Double?
  let place: String
  let time: Int64
  let url: String
  let title: String
}
