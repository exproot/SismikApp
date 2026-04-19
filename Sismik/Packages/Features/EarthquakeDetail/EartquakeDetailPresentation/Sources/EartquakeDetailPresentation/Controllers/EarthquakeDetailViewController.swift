//
//  EarthquakeDetailViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class EarthquakeDetailViewController: UIViewController {

  // MARK: Dependencies
  private let viewModel: EarthquakeDetailViewModel

  // MARK: UI Components
  private let contentView: EarthquakeDetailView

  // MARK: Init
  init(viewModel: EarthquakeDetailViewModel) {
    self.viewModel = viewModel
    self.contentView = EarthquakeDetailView()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle
  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("detail.navigation.title", comment: "")
    bindViewModel()

    contentView.setMapTapAction { [weak self] in
      self?.viewModel.didTapMap()
    }

  }

  // MARK: Binding
  private func bindViewModel() {
    contentView.configure(with: viewModel)
  }

}
