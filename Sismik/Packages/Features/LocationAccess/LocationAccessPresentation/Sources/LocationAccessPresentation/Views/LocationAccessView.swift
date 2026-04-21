//
//  LocationAccessView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import SwiftUI

struct LocationAccessView: View {
  
  let viewModel: LocationAccessViewModel
  
  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "location.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .foregroundStyle(Color.blue)

      Text(NSLocalizedString("locationAccess.title", comment: ""))
        .font(.headline)
        .bold()

      Text(NSLocalizedString("locationAccess.desc", comment: ""))
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)

      Button {
        viewModel.didSelectOpenSettings()
      } label: {
        Text(NSLocalizedString("locationAccess.button.settings", comment: ""))
          .foregroundStyle(Color.blue)
      }
    }
    .padding()
  }
}

#Preview {
  LocationAccessView(
    viewModel: LocationAccessViewModel(
      actions: LocationAccessViewModelActions(didRequestOpenSettings: { })
    )
  )
}
