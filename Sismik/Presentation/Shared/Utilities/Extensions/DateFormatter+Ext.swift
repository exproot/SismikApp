//
//  DateFormatter+Ext.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

extension DateFormatter {
  static let earthquakeAPIFormatter: DateFormatter = {
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
