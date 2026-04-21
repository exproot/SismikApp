//
//  OnboardingViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import Combine
import UIKit

class OnboardingViewController: UIPageViewController {
  
  private let viewModel: OnboardingViewModel
  private var cancellables = Set<AnyCancellable>()
  private lazy var pageViewControllers: [OnboardingPageViewController] = {
    viewModel.pages.map { OnboardingPageViewController(page: $0) }
  }()

  private lazy var pageControl: UIPageControl = {
    let control = UIPageControl()
    control.numberOfPages = viewModel.pages.count
    control.currentPage = 0
    control.currentPageIndicatorTintColor = .label
    control.pageIndicatorTintColor = .systemGray3
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    dataSource = self
    delegate = self
    
    if let firstPage = pageViewControllers.first {
      setViewControllers([firstPage], direction: .forward, animated: false)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()
  }
  
  private func bindViewModel() {
    viewModel.currentPagePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] index in
        self?.pageControl.currentPage = index
        self?.showPage(at: index)
      }
      .store(in: &cancellables)
    
    viewModel.buttonTitlePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] title in
        self?.updateButtonTitle(title)
      }
      .store(in: &cancellables)
  }
  
  private func showPage(at index: Int) {
    guard pageViewControllers.indices.contains(index) else { return }
    
    if let currentVC = viewControllers?.first as? OnboardingPageViewController,
       let currentIndex = pageViewControllers.firstIndex(of: currentVC),
       currentIndex == index {
      return
    }
    
    guard let currentVC = viewControllers?.first as? OnboardingPageViewController,
          let currentIndex = pageViewControllers.firstIndex(of: currentVC)
    else {
      setViewControllers([pageViewControllers[index]], direction: .forward, animated: false)
      return
    }
    
    let direction: UIPageViewController.NavigationDirection = index >= currentIndex
    ? .forward
    : .reverse
    
    setViewControllers([pageViewControllers[index]], direction: direction, animated: true)
  }
  
  private func updateButtonTitle(_ title: String) {
    var configuration = UIButton.Configuration.filled()
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = .systemBackground
    configuration.baseBackgroundColor = .systemBlue
    configuration.buttonSize = .large
    configuration.title = title
    
    nextButton.configuration = configuration
  }

  private func setupUI() {
    view.addSubview(pageControl)
    view.addSubview(nextButton)

    NSLayoutConstraint.activate([
      nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
      nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }

  @objc private func nextTapped() {
    viewModel.didTapNext()
  }

}

// MARK: UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let page = viewController as? OnboardingPageViewController,
          let index = pageViewControllers.firstIndex(of: page),
          let previousIndex = viewModel.previousIndex(from: index)
    else {
      return nil
    }
    
    return pageViewControllers[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let page = viewController as? OnboardingPageViewController,
          let index = pageViewControllers.firstIndex(of: page),
          let nextIndex = viewModel.nextIndex(from: index)
    else {
      return nil
    }
    return pageViewControllers[nextIndex]
  }
}

// MARK: UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard
      completed,
      let visibleVC = viewControllers?.first as? OnboardingPageViewController,
      let index = pageViewControllers.firstIndex(of: visibleVC)
    else { return }
    
    viewModel.updateCurrentPage(to: index)
  }
}
