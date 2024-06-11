//
//  EventsViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

protocol IEventsView: AnyObject {
	func reloadEventsCollection()
	func addRowEventsCollection(startIndex: Int, endIndex: Int)
}

final class EventsViewController: UIViewController {
	// MARK: - Dependencies
	
	private let presenter: IEventsPresenter
	
	// MARK: - Private properties

	private lazy var contentView: EventsView = EventsView()
	
	// MARK: - Initialization
	
	init(presenter: IEventsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
		presenter.viewIsReady(view: self)
	}
}

// MARK: - Action

private extension EventsViewController {
	@objc
	func favoriteButtonTapped(_ sender: UIButton) {
		print("like")
	}
}

// MARK: - SetupUI

private extension EventsViewController {
	func setupUI() {
		navigationBarSetup()
		eventsCollectionViewSetup()
	}
	
	func navigationBarSetup() {
	}
	
	func eventsCollectionViewSetup() {
		contentView.eventsCollectionView.delegate = self
		contentView.eventsCollectionView.dataSource = self
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension EventsViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		EventsView.Sections.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let sectionType = EventsView.Sections(rawValue: section) else {
			return .zero
		}
		switch sectionType {
		case .recomendation:
			return 0
			
		case .regular:
			return presenter.numberOfEvents()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let sectionType = EventsView.Sections(rawValue: indexPath.section) else {
			return UICollectionViewCell()
		}
		switch sectionType {

		case .recomendation:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EventViewCell.identifier,
				for: indexPath
			) as? EventViewCell else {
				return UICollectionViewCell()
			}
			
			return cell
			
		case .regular:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EventViewCell.identifier,
				for: indexPath
			) as? EventViewCell else {
				return UICollectionViewCell()
			}
			
			let event = presenter.item(at: indexPath.row)
			
			cell.favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
			cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
			cell.configure(
				image: event.image,
				title: event.title,
				date: event.date,
				place: event.place,
				price: event.price
			)

			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let sectionType = EventsView.Sections(rawValue: indexPath.section) else {
			return UICollectionReusableView()
		}
		switch sectionType {
		case .recomendation:
			guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: EventsSectionHeaderView.identifier,
				for: indexPath
			) as? EventsSectionHeaderView else {
				return UICollectionReusableView()
			}
			supplementaryView.configure(text: "Рекомендованные")
			return supplementaryView
			
		case .regular:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter.routeToDetailsScreen(indexEvent: indexPath.item)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.item == presenter.numberOfEvents() - 2 {
			presenter.fetchNextPage()
		}
	}
}

extension EventsViewController: UICollectionViewDelegate {
	
}

// MARK: - IEventListViewController

extension EventsViewController: IEventsView {
	func reloadEventsCollection() {
		contentView.eventsCollectionView.reloadData()
	}
	
	func addRowEventsCollection(startIndex: Int, endIndex: Int) {
		var indexPaths: [IndexPath] = []
		for index in startIndex...endIndex {
			indexPaths.append(IndexPath(item: index, section: 1))
		}
		contentView.eventsCollectionView.performBatchUpdates({
			contentView.eventsCollectionView.insertItems(at: indexPaths)
		}, completion: nil)
	}
}
