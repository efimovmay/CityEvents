//
//  FavoriteViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

protocol IFavoriteView: AnyObject {
	func reloadFavoriteTable()
	func deleteRow(at index: Int)
	func showTable() 
	func hideTable()
}

final class FavoriteViewController: UIViewController {
	
	private let presenter: IFavoritePresenter
	private lazy var contentView = FavoriteView()
	
	// MARK: - Initialization
	
	init(presenter: IFavoritePresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - Initialization
	
	override func loadView() {
		view = contentView
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewIsReady(view: self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter.reloadEvents()
	}
}

// MARK: - SetupUI

private extension FavoriteViewController {
	func setupUI() {
		navigationController?.navigationBar.prefersLargeTitles = true
		title = L10n.TabBar.favorite
		
		contentView.favoriteTableView.dataSource = self
		contentView.favoriteTableView.delegate = self
	}
}

// MARK: - UICollectionViewDataSource, UITableViewDelegate

extension FavoriteViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.getEventsCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: FavoriteCell.identifier,
			for: indexPath
		) as? FavoriteCell else { return UITableViewCell() }
		
		let event = presenter.getEventAtIndex(indexPath.row)
		cell.configure(nameEvent: event.shortTitle, lastDate: event.lastDate, image: event.images.first ?? nil)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			presenter.deleteEventTaped(at: indexPath.row)
		}
	}
}

extension FavoriteViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.routeToDetailScreen(eventIndex: indexPath.row)
	}
}

// MARK: - IFavoriteView

extension FavoriteViewController: IFavoriteView {
	func reloadFavoriteTable() {
		contentView.favoriteTableView.reloadData()
	}
	
	func deleteRow(at index: Int) {
		let indexPath = IndexPath(row: index, section: .zero)

		contentView.favoriteTableView.performBatchUpdates {
			contentView.favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	func showTable() {
		contentView.favoriteTableView.isHidden = false
		contentView.emptyTableLabel.isHidden = true
	}
	
	func hideTable() {
		contentView.favoriteTableView.isHidden = true
		contentView.emptyTableLabel.isHidden = false
	}
}
