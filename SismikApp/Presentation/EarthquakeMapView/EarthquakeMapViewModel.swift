//
//  EarthquakeMapViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import MapKit

final class EarthquakeMapViewModel: ObservableObject {

  @Published var earthquakes: [Earthquake]
  @Published var selectedEarthquake: Earthquake?
  @Published var region: MKCoordinateRegion

  private let mapRegionProvider: MapRegionProviding

  init(earthquakes: [Earthquake], mapRegionProvider: MapRegionProviding) {
    self.earthquakes = earthquakes
    self.mapRegionProvider = mapRegionProvider
    self.region = mapRegionProvider.region(for: earthquakes)
  }

}
