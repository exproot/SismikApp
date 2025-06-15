//
//  QueryItemBuilder.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 15.06.2025.
//

import Foundation

protocol QueryItemBuilder {
  func build(from query: EarthquakeQuery) -> [URLQueryItem]
}
