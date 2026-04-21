//
//  OnboardingViewModel.swift
//  OnboardingPresentation
//
//  Created by Ertan Yağmur on 21.04.2026.
//

import Combine
import Foundation

struct OnboardingViewModelActions {
  let didFinish: () -> Void
}

final class OnboardingViewModel {
  
  private let actions: OnboardingViewModelActions
  
  let pages: [OnboardingPage]
  
  @Published private(set) var currentIndex: Int = 0
  
  var currentPagePublisher: AnyPublisher<Int, Never> {
    $currentIndex.eraseToAnyPublisher()
  }
  
  var isLastPagePublisher: AnyPublisher<Bool, Never> {
    $currentIndex
      .map { [weak self] index in
        guard let self else { return false }
        
        return index == self.pages.count - 1
      }
      .eraseToAnyPublisher()
  }
  
  var buttonTitlePublisher: AnyPublisher<String, Never> {
    isLastPagePublisher
      .map { isLastPage in
        isLastPage
        ? NSLocalizedString("onboarding.button.finish", comment: "")
        : NSLocalizedString("onboarding.button.next", comment: "")
      }
      .eraseToAnyPublisher()
  }
  
  init(actions: OnboardingViewModelActions) {
    self.actions = actions
    self.pages = [
      OnboardingPage(
        title: NSLocalizedString("onboarding.title1", comment: ""),
        description: NSLocalizedString("onboarding.desc1", comment: ""),
        resourceName: "globe"
      ),
      
      OnboardingPage(
        title: NSLocalizedString("onboarding.title2", comment: ""),
        description: NSLocalizedString("onboarding.desc2", comment: ""),
        resourceName: "filter"
      ),
      
      OnboardingPage(
        title: NSLocalizedString("onboarding.title3", comment: ""),
        description: NSLocalizedString("onboarding.desc3", comment: ""),
        resourceName: "map"
      )
    ]
  }
  
  func page(at index: Int) -> OnboardingPage? {
    guard pages.indices.contains(index) else { return nil }
    
    return pages[index]
  }
  
  func updateCurrentPage(to index: Int) {
    guard pages.indices.contains(index) else { return }
    
    currentIndex = index
  }
  
  func didTapNext() {
    let nextIndex = currentIndex + 1
    
    if nextIndex < pages.count {
      currentIndex = nextIndex
    } else {
      actions.didFinish()
    }
  }
  
  func previousIndex(from index: Int) -> Int? {
    let previous = index - 1
    
    return pages.indices.contains(previous) ? previous : nil
  }
  
  func nextIndex(from index: Int) -> Int? {
    let next = index + 1
    
    return pages.indices.contains(next) ? next : nil
  }
  
}
