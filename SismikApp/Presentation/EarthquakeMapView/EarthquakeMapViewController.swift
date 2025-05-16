//
//  EarthquakeMapViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 16.05.2025.
//

import Combine
import UIKit
import MapKit

final class EarthquakeMapViewController: UIViewController {

  private let viewModel: EarthquakeMapViewModel
  private let mapView = MKMapView()
  private var cancellables = Set<AnyCancellable>()
  private var popupView: EarthquakePopupView?

  init(viewModel: EarthquakeMapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMap()
    bindViewModel()

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      self?.updateBoundingOverlay()
    }
  }

  private func bindViewModel() {
    viewModel.$earthquakes
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.updateAnnotations()
      }
      .store(in: &cancellables)

    viewModel.$boundingOverlay
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.updateBoundingOverlay()
      }
      .store(in: &cancellables)

    viewModel.$region
      .receive(on: DispatchQueue.main)
      .sink { [weak self] newRegion in
        self?.mapView.setRegion(newRegion, animated: true)
      }
      .store(in: &cancellables)

    viewModel.$selectedEarthquake
      .receive(on: DispatchQueue.main)
      .sink { [weak self] quake in
        self?.showPopup(for: quake)
      }
      .store(in: &cancellables)
  }

  private func showPopup(for quake: Earthquake?) {
    popupView?.removeFromSuperview()
    guard let quake else { return }

    let popup = EarthquakePopupView(earthquake: quake)
    popup.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(popup)

    NSLayoutConstraint.activate([
      popup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      popup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      popup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])

    popup.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6) {
      popup.alpha = 1
    }

    self.popupView = popup
  }

  private func updateBoundingOverlay() {
    mapView.removeOverlays(mapView.overlays)

    if let box = viewModel.boundingOverlay {
      mapView.addOverlay(box)
    }
  }

  private func updateAnnotations() {
    mapView.removeAnnotations(mapView.annotations)

    let annotations = viewModel.earthquakes.map {
      EarthquakeAnnotation(earthquake: $0)
    }

    mapView.addAnnotations(annotations)
  }

  private func setupMap() {
    view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.isRotateEnabled = false
    mapView.isPitchEnabled = false
    mapView.setRegion(viewModel.region, animated: false)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
    tapGesture.cancelsTouchesInView = false
    mapView.addGestureRecognizer(tapGesture)
  }

}

// MARK: MKMapViewDelegate
extension EarthquakeMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

    if let circle = overlay as? MKCircle {
      let renderer = MKCircleRenderer(circle: circle)

      renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.7)
      renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.25)
      renderer.lineWidth = 2
      return renderer
    }

    return MKOverlayRenderer(overlay: overlay)
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let coordinate = view.annotation?.coordinate else { return }

    if let quake = viewModel.earthquake(matching: coordinate) {
      viewModel.selectedEarthquake = quake
    }
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let quakeAnnotation = annotation as? EarthquakeAnnotation else { return nil }

    let identifier = EarthquakePinAnnotationView.reuseIdentifier
    let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? EarthquakePinAnnotationView ?? EarthquakePinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

    view.configure(with: quakeAnnotation.magnitude)
    return view
  }
}

// MARK: Selectors
extension EarthquakeMapViewController {
  @objc private func handleMapTap() {
    viewModel.selectedEarthquake = nil
  }
}
