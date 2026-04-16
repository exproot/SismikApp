//
//  SearchSuggestionsViewModel.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import Combine
import Foundation
import MapKit

final class SearchSuggestionsViewModel: NSObject {
  private let searchCompleter: MKLocalSearchCompleter

  @Published private(set) var results: [MKLocalSearchCompletion] = []

  override init() {
    self.searchCompleter = MKLocalSearchCompleter()
    super.init()
    self.searchCompleter.delegate = self
    self.searchCompleter.resultTypes = .address
  }

  func updateQuery(_ query: String) {
    searchCompleter.queryFragment = query
  }
}

// MARK: MKLocalSearchCompleterDelegate
extension SearchSuggestionsViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    results = completer.results
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
    results = []
  }
}
