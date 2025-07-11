//
//  EarthquakeExploreSnapshotBuilder.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import UIKit

final class EarthquakeExploreSnapshotBuilder {

  enum Section: Int, CaseIterable {
    case main
  }

  func applySnapshot(
    to dataSource: UITableViewDiffableDataSource<Int, Earthquake>?,
    with earthquakes: [Earthquake],
    animatingDifferences: Bool = false
  ) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Earthquake>()

    snapshot.appendSections([Section.main.rawValue])
    snapshot.appendItems(earthquakes, toSection: Section.main.rawValue)
    dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
