//
//  EarthquakeDashboardViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

final class EarthquakeDashboardViewController: UIViewController {

  private let viewModel: EarthquakeDashboardViewModel
  private var dataSource: UICollectionViewDiffableDataSource<EarthquakeDashboardSection, EarthquakeDashboardItem>!
  private var cancellables = Set<AnyCancellable>()

  // MARK: UI Components
  private var collectionView: UICollectionView!
  private let loadingView = LoadingView()
  private let errorView = ErrorView()

  // MARK: Init
  init(viewModel: EarthquakeDashboardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupViews()
    setupBindings()
    viewModel.fetchLocationPermission()
  }

  // MARK: Binding
  private func setupBindings() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.render(state)
      }
      .store(in: &cancellables)
  }

  private func render(_ state: EarthquakeDashboardState) {
    loadingView.isHidden = true
    errorView.isHidden = true
    collectionView.isHidden = true

    switch state {
    case .loading:
      loadingView.isHidden = false

    case .loaded(let snapshot):
      collectionView.isHidden = false
      dataSource.apply(snapshot, animatingDifferences: true)

    case .error(let message):
      errorView.isHidden = false
      errorView.updateMessage(message)
      errorView.setRetryAction { [weak self] in
        self?.viewModel.loadDashboard()
      }
    }
  }

  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<EarthquakeDashboardSection, EarthquakeDashboardItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      switch item {
      case .summary(let summary):
        guard
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SummaryCell.reuseIdentifier,
            for: indexPath
          ) as? SummaryCell
        else { return UICollectionViewCell() }

        cell.configure(with: summary)
        return cell

      case .recent(let quake):
        guard
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecentEarthquakeCell.reuseIdentifier,
            for: indexPath
          ) as? RecentEarthquakeCell
        else { return UICollectionViewCell() }

        cell.configure(with: quake)
        return cell

      case .biggest(let quake):
        guard
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BiggestEarthquakeCell.reuseIdentifier,
            for: indexPath
          ) as? BiggestEarthquakeCell
        else { return UICollectionViewCell() }

        cell.configure(with: quake)
        return cell

      case .tip(let text):
        guard
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TipCell.reuseIdentifier,
            for: indexPath
          ) as? TipCell
        else { return UICollectionViewCell() }

        cell.configure(with: text)
        return cell

      case .recentPlaceholder(let text), .biggestPlaceholder(let text):
        guard
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceholderDashboardEmptyStateCell.reuseIdentifier,
            for: indexPath
          ) as? PlaceholderDashboardEmptyStateCell
        else { return UICollectionViewCell() }

        cell.configure(with: text)
        return cell
      }
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
              ofKind: UICollectionView.elementKindSectionHeader,
              withReuseIdentifier: SectionHeaderView.reuseIdentifier,
              for: indexPath
            ) as? SectionHeaderView
      else {
        return nil
      }

      let section = EarthquakeDashboardSection(rawValue: indexPath.section)
      header.configure(title: section?.title)
      return header
    }
  }

  // MARK: Setup
  private func setupCollectionView() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: EarthquakeDashboardLayoutFactory.makeLayout())
    collectionView.backgroundColor = .systemBackground
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.reuseIdentifier
    )

    collectionView.register(SummaryCell.self, forCellWithReuseIdentifier: SummaryCell.reuseIdentifier)
    collectionView.register(RecentEarthquakeCell.self, forCellWithReuseIdentifier: RecentEarthquakeCell.reuseIdentifier)
    collectionView.register(BiggestEarthquakeCell.self, forCellWithReuseIdentifier: BiggestEarthquakeCell.reuseIdentifier)
    collectionView.register(TipCell.self, forCellWithReuseIdentifier: TipCell.reuseIdentifier)
    collectionView.register(PlaceholderDashboardEmptyStateCell.self, forCellWithReuseIdentifier: PlaceholderDashboardEmptyStateCell.reuseIdentifier)

    configureDataSource()
  }

  private func setupViews() {
    view.backgroundColor = .systemBackground

    [loadingView, errorView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)

      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.topAnchor.constraint(equalTo: view.topAnchor),
        $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      $0.isHidden = true
    }
  }

}
