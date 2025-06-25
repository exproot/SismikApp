//
//  EarthquakeListViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

final class EarthquakeListViewController: UIViewController {

  // MARK: UI Components
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  private let loadingView = LoadingView()
  private let emptyView = EmptyStateView()
  private let errorView = ErrorView()

  // MARK: Dependencies
  let viewModel: DefaultEarthquakeListViewModel
  private let snapshotBuilder = EarthquakeListSnapshotBuilder()
  private var dataSource: UITableViewDiffableDataSource<Int, Earthquake>?
  private var cancellables = Set<AnyCancellable>()

  // MARK: Init
  init(viewModel: DefaultEarthquakeListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupBindings()
    viewModel.requestUserLocation()
  }

  private func handle(state: EarthquakeListViewState) {
    tableView.refreshControl?.endRefreshing()
    loadingView.isHidden = true
    emptyView.isHidden = true
    errorView.isHidden = true

    switch state {
    case .loading:
      loadingView.isHidden = false

    case .loaded(let earthquakes):
      snapshotBuilder.applySnapshot(to: dataSource, with: earthquakes)

    case .empty:
      emptyView.isHidden = false

    case .error(let message):
      errorView.isHidden = false
      errorView.updateMessage(message)
      errorView.setRetryAction { [weak self] in
        self?.viewModel.requestUserLocation()
      }
    }
  }

  // MARK: Bindings
  private func setupBindings() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.handle(state: state)
      }
      .store(in: &cancellables)
  }

  // MARK: Setup
  private func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Int, Earthquake>(tableView: tableView) { tableView, indexPath, item in
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: EarthquakeListCell.reuseIdentifier, for: indexPath) as? EarthquakeListCell
      else {
        return UITableViewCell()
      }

      cell.configure(with: item)
      return cell
    }
  }

  private func setupViews() {
    view.backgroundColor = .systemBackground
    title = NSLocalizedString("earthquakes.navigation.title", comment: "")

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "map"),
      style: .plain,
      target: self,
      action: #selector(didTapMap)
    )

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
      style: .plain,
      target: self,
      action: #selector(didTapFilter)
    )

    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.register(EarthquakeListCell.self, forCellReuseIdentifier: EarthquakeListCell.reuseIdentifier)
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    view.addSubview(tableView)

    [loadingView, emptyView, errorView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .systemBackground
      view.addSubview($0)

      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.topAnchor.constraint(equalTo: view.topAnchor),
        $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      view.bringSubviewToFront($0)
      $0.isHidden = true
    }

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    configureDataSource()
  }

  // MARK: Actions
  @objc private func didTapMap() {
    viewModel.didTapMap()
  }

  @objc private func didTapFilter() {
    viewModel.showFilter()
  }

  @objc private func handlePullToRefresh() {
    viewModel.requestUserLocation()
  }

}

// MARK: UITableViewDelegate
extension EarthquakeListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let earthquake = dataSource?.itemIdentifier(for: indexPath) else { return }

    viewModel.didSelectEarthquake(earthquake)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
