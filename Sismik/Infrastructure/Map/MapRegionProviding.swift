//
//  MapRegionProviding.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import EarthquakeDomain
import MapKit

protocol MapRegionProviding {
  func region(for earthquakes: [Earthquake]) -> MKCoordinateRegion
}
