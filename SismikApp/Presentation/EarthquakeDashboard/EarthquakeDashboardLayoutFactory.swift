//
//  EarthquakeDashboardLayoutFactory.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 26.06.2025.
//

import UIKit

enum EarthquakeDashboardLayoutFactory {
  static func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, _ in
      guard let section = EarthquakeDashboardSection(rawValue: sectionIndex) else { return nil }

      switch section {
      case .summary:
        return summarySection()
      case .recent:
        return recentSection()
      case .biggest:
        return biggestSection()
      case .tip:
        return tipSection()
      }
    }
  }

  private static func summarySection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(140))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = itemSize
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
    section.boundarySupplementaryItems = [makeHeader()]
    return section
  }

  private static func recentSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .estimated(120))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(200), heightDimension: .estimated(100))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(12)

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    section.interGroupSpacing = 12
    section.boundarySupplementaryItems = [makeHeader()]
    return section
  }

  private static func biggestSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = itemSize
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
    section.boundarySupplementaryItems = [makeHeader()]
    return section
  }

  private static func tipSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = itemSize
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    section.boundarySupplementaryItems = [makeHeader()]
    return section
  }

  private static func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))

    return NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: size,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
  }

}
