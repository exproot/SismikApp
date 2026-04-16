//
//  OnboardingPageViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//

import DotLottie
import UIKit

final class OnboardingPageViewController: UIViewController {

  private let titleText: String
  private let descriptionText: String
  private let animationName: String

  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private var animationView: DotLottieAnimationView?

  init(titleText: String, descriptionText: String, animationName: String) {
    self.titleText = titleText
    self.descriptionText = descriptionText
    self.animationName = animationName
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLottieAnimation()
    setupUI()
    view.backgroundColor = .systemBackground
  }

  private func setupLottieAnimation() {
    let anim = DotLottieAnimation(fileName: animationName, config: AnimationConfig(autoplay: true, loop: true))

    animationView = anim.view()
  }

  private func setupUI() {
    view.backgroundColor = .systemBackground

    titleLabel.text = titleText
    titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0

    descriptionLabel.text = descriptionText
    descriptionLabel.font = .systemFont(ofSize: 16)
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = .secondaryLabel

    guard let animationView else { return }

    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.contentMode = .scaleAspectFit

    let stack = UIStackView(arrangedSubviews: [animationView, titleLabel, descriptionLabel])
    stack.axis = .vertical
    stack.spacing = 20
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stack)

    NSLayoutConstraint.activate([
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
      animationView.widthAnchor.constraint(equalTo: animationView.heightAnchor),

      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

}
