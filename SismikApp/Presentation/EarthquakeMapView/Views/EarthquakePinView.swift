//
//  EarthquakePinView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import SwiftUI

struct EarthquakePinView: View {

  let magnitude: Double

  @State private var animate = false

  var body: some View {
    Text(String(format: "%.1f", magnitude))
      .font(.caption.bold())
      .foregroundStyle(Color.accentColor)
      .frame(width: 40, height: 40)
      .background(magnitude.magnitudeColor())
      .clipShape(Circle())
      .overlay {
        Circle()
          .stroke(Color.accentColor, lineWidth: 2)
      }
      .scaleEffect(animate ? 1.0 : 0.0)
      .opacity(animate ? 1.0 : 0.0)
      .onAppear {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
          animate = true
        }
      }
  }
}

#Preview {
  EarthquakePinView(magnitude: 4.4)
}
