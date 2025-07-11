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
  private var suggestionsController: SearchSuggestionsViewController!
  private var searchController: UISearchController!
  private var viewModeHeader: ExploreViewModeHeaderView?
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
    tableView.backgroundColor = .clear
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let header = viewModeHeader, viewModel.viewMode == .map {
      viewModel.updateViewMode(.list)
      header.segmentedControl.selectedSegmentIndex = 0
    }
  }

  private func renderState(_ state: EarthquakeExploreViewState) {
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
        self?.renderState(state)
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
    let suggestionsVM = SearchSuggestionsViewModel()
    suggestionsController = SearchSuggestionsViewController(viewModel: suggestionsVM)
    searchController = UISearchController(searchResultsController: suggestionsController)

    suggestionsController.didSelectSuggestion = { [weak self] suggestion in
      self?.viewModel.search(for: suggestion)
      self?.searchController.isActive = false
    }

    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = suggestionsController
    searchController.searchBar.showsBookmarkButton = true
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = NSLocalizedString("explore.search.placeholder", comment: "")

    searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
    searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: [.highlighted, .selected])

    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

  private func setupViews() {
    view.backgroundColor = .systemBackground
    title = NSLocalizedString("explore.navigation.title", comment: "")

    tableView.delegate = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 60
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    tableView.register(EarthquakeListCell.self, forCellReuseIdentifier: EarthquakeListCell.reuseIdentifier)
    tableView.register(ExploreViewModeHeaderView.self, forHeaderFooterViewReuseIdentifier: ExploreViewModeHeaderView.reuseIdentifier)
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

    configureDataSource()
  }

  // MARK: Actions
  @objc private func viewModeChanged(_ sender: UISegmentedControl) {
    if case .empty = viewModel.state {
      sender.selectedSegmentIndex = 0
      return
    }

    let selectedMode: ExploreViewMode = sender.selectedSegmentIndex == 0 ? .list : .map

    viewModel.updateViewMode(selectedMode)
  }

  @objc private func didTapMap() {
    viewModel.didTapMap()
  }

  @objc private func didTapFilter() {
    viewModel.showFilter()
  }

  @objc private func handlePullToRefresh() {
    guard let coordinate = viewModel.lastCoordinate else {
      tableView.refreshControl?.endRefreshing()
      return
    }

    viewModel.fetchFilteredEarthquakes(with: viewModel.buildQuery(with: coordinate))
  }

}

// MARK: UITableViewDelegate
extension EarthquakeExploreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let earthquake = dataSource?.itemIdentifier(for: indexPath) else { return }

    viewModel.didSelectEarthquake(earthquake)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard
      section == 0,
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExploreViewModeHeaderView.reuseIdentifier) as? ExploreViewModeHeaderView
    else {
      return nil
    }

    header.segmentedControl.addTarget(
      self,
      action: #selector(viewModeChanged(_:)),
      for: .valueChanged
    )

    header.segmentedControl.selectedSegmentIndex = viewModel.viewMode == .map ? 1 : 0
    viewModeHeader = header

    return header
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    56
  }
}

// MARK: UISearchBarDelegate
extension EarthquakeExploreViewController: UISearchBarDelegate {
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    didTapFilter()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let query = searchBar.text, !query.isEmpty else { return }

    viewModel.search(for: query)
  }

}
