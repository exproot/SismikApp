//
//  SearchSuggestionsViewController.swift
//  SismikApp
//
//  Created by Ertan Yağmur on 8.07.2025.
//

import Combine
import UIKit
import MapKit

final class SearchSuggestionsViewController: UIViewController {

  private let viewModel: SearchSuggestionsViewModel
  private var cancellables = Set<AnyCancellable>()

  // MARK: UI
  private let tableView = UITableView()

  // MARK: Callback
  var didSelectSuggestion: ((String) -> Void)?

  // MARK: Lifecycle
  init(viewModel: SearchSuggestionsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupBindings()
  }

  private func setupBindings() {
    viewModel.$results
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
  }

  func updateSearchQuery(_ query: String) {
    viewModel.updateQuery(query)
  }

  // MARK: UI Setup
  private func setupViews() {
    view.backgroundColor = .systemBackground
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: UITableViewDelegate & DataSource
extension SearchSuggestionsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
    let result = viewModel.results[indexPath.row]
    var config = cell.defaultContentConfiguration()

    config.text = result.title + ", " + result.subtitle
    cell.contentConfiguration = config
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let suggestion = viewModel.results[indexPath.row].title
    didSelectSuggestion?(suggestion)
  }
}

// MARK: UISearchResultsUpdating
extension SearchSuggestionsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text, !query.isEmpty else {
      viewModel.updateQuery("")
      return
    }

    updateSearchQuery(query)
  }
}
