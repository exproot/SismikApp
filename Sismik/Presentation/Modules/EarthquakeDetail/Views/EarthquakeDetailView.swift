//
//  EarthquakeDetailView.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import UIKit

final class EarthquakeDetailView: UIView {

  // MARK: Components
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()

  private let titleLabel = UILabel()
  private let locationLabel = UILabel()
  private let depthLabel = UILabel()
  private let timeLabel = UILabel()
  private let mapViewContainer = UIView()
  private var miniMapView: MiniMapView?

  // MARK: Callback
  private var mapTapAction: (() -> Void)?

  // MARK: Lifecycle
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configuration
  func configure(with viewModel: EarthquakeDetailViewModel) {
    titleLabel.text = viewModel.title
    titleLabel.textColor = UIColor(named: "AccentColor")
    titleLabel.numberOfLines = 0

    locationLabel.text = viewModel.locationText
    depthLabel.text = viewModel.depthText
    timeLabel.text = viewModel.timeText

    let map = MiniMapView(quake: viewModel.quake)
    map.translatesAutoresizingMaskIntoConstraints = false
    miniMapView = map
    mapViewContainer.addSubview(map)
    NSLayoutConstraint.activate([
      map.topAnchor.constraint(equalTo: mapViewContainer.topAnchor),
      map.bottomAnchor.constraint(equalTo: mapViewContainer.bottomAnchor),
      map.leadingAnchor.constraint(equalTo: mapViewContainer.leadingAnchor),
      map.trailingAnchor.constraint(equalTo: mapViewContainer.trailingAnchor)
    ])
  }

  func setMapTapAction(_ action: @escaping () -> Void) {
    mapTapAction = action
  }

  // MARK: Setup
  private func divider() -> UIView {
    let divider = UIView()
    divider.backgroundColor = .separator
    divider.translatesAutoresizingMaskIntoConstraints = false
    divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    return divider
  }

  private func setup() {
    backgroundColor = .systemBackground
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(scrollView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
    ])

    titleLabel.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))

    [locationLabel, depthLabel, timeLabel].forEach {
      $0.font = .preferredFont(forTextStyle: .body)
      $0.numberOfLines = 0
    }

    let infoStack = UIStackView(arrangedSubviews: [locationLabel, depthLabel, timeLabel])
    infoStack.axis = .vertical
    infoStack.spacing = 8

    mapViewContainer.translatesAutoresizingMaskIntoConstraints = false
    mapViewContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
    mapViewContainer.layer.borderColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.4).cgColor
    mapViewContainer.layer.borderWidth = 1
    mapViewContainer.layer.cornerRadius = 12
    mapViewContainer.clipsToBounds = true

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapMap))
    mapViewContainer.addGestureRecognizer(tap)

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(divider())
    stackView.addArrangedSubview(infoStack)
    stackView.addArrangedSubview(divider())
    stackView.addArrangedSubview(mapViewContainer)
  }

  // MARK: Actions
  @objc private func didTapMap() {
    mapTapAction?()
  }

}
