//
//  OnboardingPageViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 31.05.2025.
//


import UIKit

final class OnboardingPageViewController: UIViewController {

  private let titleText: String
  private let descriptionText: String
  private let imageName: String

  init(titleText: String, descriptionText: String, imageName: String) {
    self.titleText = titleText
    self.descriptionText = descriptionText
    self.imageName = imageName
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupUI()
  }

  private func setupUI() {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit

    let titleLabel = UILabel()
    titleLabel.text = titleText
    titleLabel.font = .boldSystemFont(ofSize: 24)
    titleLabel.textAlignment = .center

    let descriptionLabel = UILabel()
    descriptionLabel.text = descriptionText
    descriptionLabel.font = .systemFont(ofSize: 16)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textAlignment = .center

    let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }

}
