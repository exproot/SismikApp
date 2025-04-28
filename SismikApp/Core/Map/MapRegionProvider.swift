//
//  MapRegionProvider.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import MapKit

final class MapRegionProvider: MapRegionProviding {

  func region(for earthquakes: [Earthquake]) -> MKCoordinateRegion {
    guard let first = earthquakes.first else {
      return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
      )
    }

    return MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
      span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
  }

}
