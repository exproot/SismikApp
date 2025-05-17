//
//  FilterSummaryBannerView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//


import SwiftUI

struct FilterSummaryBannerView: View {

  let text: String

  var body: some View {
    Text(text)
      .font(.caption)
      .foregroundStyle(Color.secondary)
      .multilineTextAlignment(.leading)
    
  }

}
