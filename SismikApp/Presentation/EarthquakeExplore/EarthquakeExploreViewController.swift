//
//  EarthquakeExploreViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 25.06.2025.
//

import Combine
import UIKit

final class EarthquakeExploreViewController: UIViewController {

  // MARK: UI Components
  private let searchController = UISearchController(searchResultsController: nil)
  private let tableView = UITableView(frame: .zero, style: .insetGrouped)
  private let loadingView = LoadingView()
  private let emptyView = EmptyStateView()
  private let errorView = ErrorView()

  // MARK: Dependencies
  let viewModel: EarthquakeExploreViewModel
  private let snapshotBuilder = EarthquakeExploreSnapshotBuilder()
  private var dataSource: UITableViewDiffableDataSource<Int, Earthquake>?
  private var cancellables = Set<AnyCancellable>()

  // MARK: Init
  init(viewModel: EarthquakeExploreViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
    setupViews()
    setupBindings()
  }

  private func handle(state: EarthquakeExploreViewState) {
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
        guard let query = self?.searchController.searchBar.text, !query.isEmpty else { return }
        self?.viewModel.search(for: query)
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

  private func setupSearchController() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = NSLocalizedString("explore.search.placeholder", comment: "")
    searchController.searchBar.delegate = self
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

  private func setupTableHeader() {
    let header = ExploreActionHeaderView()
    header.mapButton.addTarget(self, action: #selector(didTapMap), for: .touchUpInside)
    header.filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)

    header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 56)
    tableView.tableHeaderView = header
  }

  private func setupViews() {
    view.backgroundColor = .systemBackground
    title = NSLocalizedString("explore.navigation.title", comment: "")

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
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    setupTableHeader()
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
    guard let last = viewModel.lastQuery else {
      tableView.refreshControl?.endRefreshing()
      return
    }

    viewModel.fetchFilteredEarthquakes(with: last)
  }

}

// MARK: UITableViewDelegate
extension EarthquakeExploreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let earthquake = dataSource?.itemIdentifier(for: indexPath) else { return }

    viewModel.didSelectEarthquake(earthquake)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: UISearchBarDelegate
extension EarthquakeExploreViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let query = searchBar.text, !query.isEmpty else { return }

    viewModel.search(for: query)
  }
}
