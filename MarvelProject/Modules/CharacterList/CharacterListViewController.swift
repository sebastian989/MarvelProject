//
//  CharacterListViewController.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import UIKit
import Combine

class CharacterListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: CharacterListViewModel!
    private var subscriptions = Set<AnyCancellable>()
    private var loadingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel = CharacterListViewModel()
        viewModel.pagingDelegate = self
        viewModel.loadCharacters()
    }
    
    private func setupUI() {
        setupTitleView()
        loadingView = CustomLoadingView.create()
        loadingView?.frame = tableView.bounds
        tableView.backgroundView = loadingView
        tableView.register(
            UINib(nibName: CharacterTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
    
    private func setupTitleView() {
        let titleView = UIImageView(image: UIImage(named: "marvel"))
        let navigationSize = navigationController?.navigationBar.frame
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: (navigationSize?.height ?? 20) * 0.5),
            titleView.widthAnchor.constraint(equalToConstant: (navigationSize?.width ?? 60) * 0.5)
        ])
        navigationItem.titleView = titleView
    }
    
    private func hideLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
        tableView.backgroundView = nil
    }
    
    private func navigateToDetailView(character: Character) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "CharacterDetailViewController") as? CharacterDetailViewController else {
            return
        }
        detailVC.viewModel = CharacterDetailViewModel(character: character)
        navigationController?.show(detailVC, sender: nil)
    }
}

extension CharacterListViewController: ViewPaginationDelegate {
    func onFetchCompleted(with indexToReload: [Int]?) {
        hideLoading()
        guard let indexToReload = indexToReload else {
            tableView.reloadData()
            return
        }
        
        let indexPaths = indexToReload.map { IndexPath(row: $0, section: 0) }
        let indexPathsToReload = visibleIndexPathsToReload(intercecting: indexPaths)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        hideLoading()
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCharacters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = CharacterTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CharacterTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            let character = viewModel.character(at: indexPath.row)
            cell.configure(with: CharacterViewModel(character: character))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.loadCharacters()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isLoadingCell(for: indexPath) else { return }
        let selectedCharacter = viewModel.character(at: indexPath.row)
        navigateToDetailView(character: selectedCharacter)
    }
}

private extension CharacterListViewController  {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.numberOfCharacters
    }
    
    func visibleIndexPathsToReload(intercecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathIntersection = Set(indexPathForVisibleRows).intersection(indexPaths)
        
        return Array(indexPathIntersection)
    }
}
