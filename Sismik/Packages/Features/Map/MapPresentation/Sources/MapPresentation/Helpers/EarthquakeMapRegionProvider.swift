//
//  EarthquakeMapRegionProvider.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import EarthquakeDomain
import MapKit

final class EarthquakeMapRegionProvider {

  func region(for earthquakes: [Earthquake]) -> MKCoordinateRegion {
    guard !earthquakes.isEmpty else {
      return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
      )
    }
    
    let latitudes = earthquakes.map(\.latitude)
    let longitudes = earthquakes.map(\.longitude)
    
    guard
      let minLat = latitudes.min(),
      let maxLat = latitudes.max(),
      let minLon = longitudes.min(),
      let maxLon = longitudes.max()
    else {
      return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
      )
    }
    
    let center = CLLocationCoordinate2D(
      latitude: (minLat + maxLat) / 2,
      longitude: (minLon + maxLon) / 2
    )
    
    let span = MKCoordinateSpan(
      latitudeDelta: max((maxLat - minLat) * 1.4, 0.5),
      longitudeDelta: max((maxLon - minLon) * 1.4, 0.5)
    )
    
    return MKCoordinateRegion(center: center, span: span)
  }

}
