//
//  Earthquake.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.04.2025.
//


import Foundation

struct Earthquake {
  let id: String
  let title: String
  let magnitude: Double
  let place: String
  let time: Date
  let latitude: Double
  let longitude: Double
  let depth: Double


  static let sampleEarthquake = Earthquake(
    id: "0",
    title: "M 4.3 - 19 km S of Kumburgaz, Turkey",
    magnitude: 4.3,
    place: "35 km S of Kumburgaz, Turkey",
    time: Date(),
    latitude: 28.4496,
    longitude: 40.8476,
    depth: 13.696
  )
}
