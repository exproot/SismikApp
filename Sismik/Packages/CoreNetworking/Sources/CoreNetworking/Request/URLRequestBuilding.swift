//
//  URLRequestBuilding.swift
//  SismikNetworking
//
//  Created by Ertan Yağmur on 16.04.2026.
//

import Foundation

public protocol URLRequestBuilding {
  func build(from request: Requestable) throws -> URLRequest
}
