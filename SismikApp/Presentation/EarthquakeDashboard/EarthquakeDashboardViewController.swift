//
//  EarthquakeDashboardViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

enum EarthquakeDashboardSection: Int, CaseIterable {
  case summary
  case recent
  case biggest
  case tip

  var title: String? {
    switch self {
    case .summary:
      return NSLocalizedString("dashboard.section.summary.title", comment: "")
    case .recent:
      return NSLocalizedString("dashboard.section.recent.title", comment: "")
    case .biggest:
      return NSLocalizedString("dashboard.section.biggest.title", comment: "")
    case .tip:
      return NSLocalizedString("dashboard.section.tip.title", comment: "")
    }
  }
}

enum EarthquakeDashboardItem: Hashable {
  case summary(EarthquakeDashboardSummaryItem)
  case recent(Earthquake)
  case biggest(Earthquake)
  case tip(String)
}

final class EarthquakeDashboardViewController: UIViewController {

  private let viewModel: EarthquakeDashboardViewModel
  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<EarthquakeDashboardSection, EarthquakeDashboardItem>!
  private var cancellables = Set<AnyCancellable>()

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
    setupBindings()
    viewModel.fetchLocationPermission()
  }

  // MARK: Binding
  private func setupBindings() {
    viewModel.$snapshot
      .receive(on: DispatchQueue.main)
      .sink { [weak self] snapshot in
        self?.dataSource.apply(snapshot, animatingDifferences: true)
      }
      .store(in: &cancellables)
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

    collectionView.register(RecentEarthquakeCell.self,
                            forCellWithReuseIdentifier: RecentEarthquakeCell.reuseIdentifier)

    collectionView.register(BiggestEarthquakeCell.self,
                            forCellWithReuseIdentifier: BiggestEarthquakeCell.reuseIdentifier)

    collectionView.register(TipCell.self, forCellWithReuseIdentifier: TipCell.reuseIdentifier)

    configureDataSource()
  }

}
