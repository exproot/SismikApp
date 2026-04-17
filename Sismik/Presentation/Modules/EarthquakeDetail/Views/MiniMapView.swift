//
//  MiniMapView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 16.05.2025.
//

import EarthquakeDomain
import MapKit

final class MiniMapView: UIView {

  private let mapView = MKMapView()

  init(quake: Earthquake) {
    super.init(frame: .zero)
    setupMap(quake: quake)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupMap(quake: Earthquake) {

    let coordinate = CLLocationCoordinate2D(latitude: quake.latitude, longitude: quake.longitude)

    mapView.isUserInteractionEnabled = false
    mapView.tintColor = UIColor(named: "AccentColor")
    mapView.layer.cornerRadius = 12
    mapView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: topAnchor),
      mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    let region = MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5))
    mapView.setRegion(region, animated: false)

    let annotation = EarthquakeAnnotation(earthquake: quake)
    mapView.addAnnotation(annotation)
    mapView.register(EarthquakePinAnnotationView.self, forAnnotationViewWithReuseIdentifier: EarthquakePinAnnotationView.reuseIdentifier)
    mapView.delegate = self
  }

}

// MARK: MKMapViewDelegate
extension MiniMapView: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let quakeAnnotation = annotation as? EarthquakeAnnotation else { return nil }

    let identifier = EarthquakePinAnnotationView.reuseIdentifier
    let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? EarthquakePinAnnotationView ?? EarthquakePinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

    view.configure(with: quakeAnnotation.magnitude)
    return view
  }
}
