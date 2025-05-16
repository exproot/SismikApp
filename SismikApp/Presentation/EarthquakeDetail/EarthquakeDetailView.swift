//
//  EarthquakeDetailView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import MapKit
import SwiftUI

final class MiniMapView: UIView, MKMapViewDelegate {

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

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let quakeAnnotation = annotation as? EarthquakeAnnotation else { return nil }

    let identifier = EarthquakePinAnnotationView.reuseIdentifier
    let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? EarthquakePinAnnotationView ?? EarthquakePinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

    view.configure(with: quakeAnnotation.magnitude)
    return view
  }

}

struct MiniMapViewWrapper: UIViewRepresentable {

  let earthquake: Earthquake

  func makeUIView(context: Context) -> MiniMapView {
    MiniMapView(quake: earthquake)
  }

  func updateUIView(_ uiView: MiniMapView, context: Context) {}

}

struct EarthquakeDetailView: View {

  @ObservedObject var viewModel: EarthquakeDetailViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        // Title
        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.title)
            .font(.title2.bold())

          Label(viewModel.magnitudeText, systemImage: "waveform.path.ecg")
            .foregroundStyle(viewModel.magnitudeColor)
        }

        Divider()

        // Info Section
        VStack(alignment: .leading, spacing: 12) {
          Label(viewModel.locationText, systemImage: "location.fill")
          Label(viewModel.depthText, systemImage: "arrow.down.to.line")
          Label(viewModel.timeText, systemImage: "clock")
        }
        .font(.body)

        Divider()

        MiniMapViewWrapper(earthquake: viewModel.quake)
          .frame(height: 200)
          .onTapGesture {
            viewModel.showEarthquakeMap?([viewModel.quake])
          }
      }
      .padding()
    }
    .navigationTitle("Details")
  }
}



