//
//  EmptyStateView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 28.04.2025.
//

import SwiftUI

struct EmptyStateView: View {

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "exclamationmark.triangle")
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .foregroundStyle(Color.orange)

      Text(NSLocalizedString("earthquakes.emptyState.title", comment: ""))
        .font(.title2)
        .fontWeight(.semibold)

      Text(NSLocalizedString("earthquakes.emptyState.desc", comment: ""))
        .font(.body)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.secondary)
        .padding(.horizontal, 32)
    }
    .padding()
  }

}

#Preview {
  EmptyStateView()
}
