//
//  OnboardingViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import UIKit

class OnboardingViewController: UIPageViewController {

  private let pages: [UIViewController]
  private var currentIndex = 0

  private lazy var pageControl: UIPageControl = {
    let control = UIPageControl()
    control.numberOfPages = pages.count
    control.currentPage = currentIndex
    control.currentPageIndicatorTintColor = .label
    control.pageIndicatorTintColor = .systemGray3
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()

  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    var configuration = UIButton.Configuration.filled()

    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = .systemBackground
    configuration.baseBackgroundColor = .systemBlue
    configuration.buttonSize = .large
    configuration.title = NSLocalizedString("onboarding.button.next", comment: "")

    button.configuration = configuration
    button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  var onFinish: (() -> Void)?

  init() {
    let page1 = OnboardingPageViewController(
      titleText: NSLocalizedString("onboarding.title1", comment: ""),
      descriptionText: NSLocalizedString("onboarding.desc1", comment: ""),
      animationName: "globe"
    )

    let page2 = OnboardingPageViewController(
      titleText: NSLocalizedString("onboarding.title2", comment: ""),
      descriptionText: NSLocalizedString("onboarding.desc2", comment: ""),
      animationName: "filter"
    )

    let page3 = OnboardingPageViewController(
      titleText: NSLocalizedString("onboarding.title3", comment: ""),
      descriptionText: NSLocalizedString("onboarding.desc3", comment: ""),
      animationName: "map"
    )

    self.pages = [page1, page2, page3]

    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.dataSource = self
    self.delegate = self

    setViewControllers([pages[0]], direction: .forward, animated: true)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
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
    let nextIndex = currentIndex + 1

    if nextIndex < pages.count {
      setViewControllers([pages[nextIndex]], direction: .forward, animated: true)
      currentIndex = nextIndex
      pageControl.currentPage = currentIndex
    } else {
      onFinish?()
    }
  }

}

// MARK: UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
    return pages[index - 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
    return pages[index + 1]
  }
}

// MARK: UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let visibleVC = viewControllers?.first,
       let index = pages.firstIndex(of: visibleVC) {
      currentIndex = index
      pageControl.currentPage = index
    }
  }
}
