//
//  EarthquakeDetailViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//


import SwiftUI

final class EarthquakeDetailViewModel: ObservableObject {
  let title: String
  let magnitudeText: String
  let timeText: String
  let locationText: String
  let depthText: String

  init(earthquake: Earthquake) {
    title = earthquake.title
    magnitudeText = "Magnitude: \(earthquake.magnitude)"
    timeText = earthquake.time.formatEarthquakeDate()
    locationText = "Location: \(String(format: "%.3f", earthquake.latitude)), \(String(format: "%.3f", earthquake.longitude))"
    depthText = "Depth: \(String(format: "%1.f", earthquake.depth)) km"
  }
}