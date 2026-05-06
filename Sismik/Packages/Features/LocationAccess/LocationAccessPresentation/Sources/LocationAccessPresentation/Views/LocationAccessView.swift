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
      
      Button(action: viewModel.didSelectClose) {
        Text(NSLocalizedString("common.close", comment: ""))
          .foregroundStyle(Color.red)
      }
    }
    .padding()
  }
}

#Preview {
  let actions = LocationAccessViewModelActions(
    didRequestOpenSettings: { },
    didRequestClose: { }
  )
  
  LocationAccessView(
    viewModel: LocationAccessViewModel(actions: actions)
  )
}
