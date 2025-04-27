//
//  ErrorView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//


import SwiftUI

struct ErrorView: View {

  let message: String
  let retryAction: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      Text(message)
        .font(.headline)
        .foregroundStyle(Color.secondary)
        .multilineTextAlignment(.center)

      Button(action: retryAction) {
        Text("Retry")
          .padding()
      }
    }
    .padding()
  }

}
