//
//  EarthquakeDetailViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import EarthquakeDomain
import MapKit

public struct EarthquakeDetailContext {
  public let earthquake: Earthquake
  
  public init(earthquake: Earthquake) {
    self.earthquake = earthquake
  }
}

struct EarthquakeDetailViewModelActions {
  let didRequestMap: (Earthquake) -> Void
}

final class EarthquakeDetailViewModel {

  // MARK: Dependencies
  private let actions: EarthquakeDetailViewModelActions
  private let context: EarthquakeDetailContext
  
  let earthquake: Earthquake
  let title: String
  let magnitudeText: String
  let timeText: String
  let locationText: String
  let depthText: String
  let coordinate: CLLocationCoordinate2D
  let magnitudeColor: UIColor

  // MARK: Init
  init(
    actions: EarthquakeDetailViewModelActions,
    context: EarthquakeDetailContext
  ) {
    self.actions = actions
    self.context = context
    self.earthquake = context.earthquake

    title = context.earthquake.title

    magnitudeText = String(
      format: NSLocalizedString("detail.magnitude", comment: ""),
      context.earthquake.magnitude
    )

    locationText = String(
      format: NSLocalizedString("detail.location", comment: ""),
      context.earthquake.latitude,
      context.earthquake.longitude
    )

    depthText = String(
      format: NSLocalizedString("detail.depth", comment: ""),
      context.earthquake.depth
    )

    magnitudeColor = context.earthquake.magnitude.magnitudeColor()

    timeText = context.earthquake.time.formattedEarthquakeDisplayText()
    coordinate = CLLocationCoordinate2D(latitude: context.earthquake.latitude, longitude: context.earthquake.longitude)
  }
  
  func didTapMap() {
    actions.didRequestMap(earthquake)
  }

}
