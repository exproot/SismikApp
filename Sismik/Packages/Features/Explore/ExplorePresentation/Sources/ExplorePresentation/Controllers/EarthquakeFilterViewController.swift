//
//  EarthquakeFilterViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 17.05.2025.
//

import UIKit

final class EarthquakeFilterViewController: UIViewController {

  private let viewModel: EarthquakeFilterViewModel

  // UI
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  private var dataSource: UITableViewDiffableDataSource<FilterSection, FilterItem>!

  init(viewModel: EarthquakeFilterViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Filter Earthquakes"
    view.backgroundColor = .systemBackground
    setupUI()
    setupTableView()
    applySnapshot()
    bindViewModel()
  }

  private func bindViewModel() {
    viewModel.onUIUpdate = { [weak self] in
      self?.applySnapshot()
    }
  }

  func applySnapshot() {
    let snapshot = EarthquakeFilterSnapshotBuilder.build(from: viewModel)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func setupTableView() {
    tableView.register(SliderCell.self, forCellReuseIdentifier: SliderCell.reuseIdentifier)
    tableView.register(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.reuseIdentifier)
    tableView.register(ButtonGroupCell.self, forCellReuseIdentifier: ButtonGroupCell.reuseIdentifier)

    dataSource = UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
      switch item {
      case .slider(let sliderViewModel):
        let cell = tableView.dequeueReusableCell(withIdentifier: SliderCell.reuseIdentifier, for: indexPath) as! SliderCell

        cell.configure(with: sliderViewModel)
        return cell

      case .datePicker(let dateViewModel):
        let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.reuseIdentifier, for: indexPath) as! DatePickerCell

        cell.configure(with: dateViewModel)
        return cell

      case .buttonGroup(let buttonGroupVM):
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonGroupCell.reuseIdentifier, for: indexPath) as! ButtonGroupCell

        cell.configure(with: buttonGroupVM)
        return cell
      }
    }

    tableView.dataSource = dataSource
    tableView.delegate = self
  }

  private func setupUI() {
    view.addSubview(tableView)
    tableView.allowsSelection = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: UITableViewDelegate
extension EarthquakeFilterViewController: UITableViewDelegate {}
