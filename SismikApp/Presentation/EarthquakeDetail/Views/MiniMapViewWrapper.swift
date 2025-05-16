//
//  MiniMapViewWrapper.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 16.05.2025.
//


import MapKit
import SwiftUI

struct MiniMapViewWrapper: UIViewRepresentable {

  let earthquake: Earthquake

  func makeUIView(context: Context) -> MiniMapView {
    MiniMapView(quake: earthquake)
  }

  func updateUIView(_ uiView: MiniMapView, context: Context) {}

}