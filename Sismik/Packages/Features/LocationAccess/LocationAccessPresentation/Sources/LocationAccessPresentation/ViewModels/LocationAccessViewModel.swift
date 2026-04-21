//
//  LocationAccessViewModel.swift
//  LocationAccessPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import Foundation

struct LocationAccessViewModelActions {
  let didRequestOpenSettings: () -> Void
}

struct LocationAccessViewModel {
  
  private let actions: LocationAccessViewModelActions
  
  init(actions: LocationAccessViewModelActions) {
    self.actions = actions
  }
  
  func didSelectOpenSettings() {
    actions.didRequestOpenSettings()
  }
  
}
