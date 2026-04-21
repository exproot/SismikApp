//
//  EarthquakeAnnotation.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 16.05.2025.
//

import EarthquakeDomain
import UIKit
import MapKit

final class EarthquakeAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let magnitude: Double
  let title: String?

  init(earthquake: Earthquake) {
    self.coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
    self.magnitude = earthquake.magnitude
    self.title = earthquake.title
  }
}
