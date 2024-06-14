//
//  EventsViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

protocol IEventsView: AnyObject {
	func setLocation(_ location: String)
	func addRowEventsCollection(startIndex: Int, endIndex: Int)
	func reloadEventsCollection()
	func reloadSection(_ section: Int)
	func reloadCell(section: Int, cellIndex: Int)
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
	
	@objc
	func setLocationButtonTapped() {
		print("Location")
	}
	
	@objc
	func setDateButtonTapped() {
		presenter.routeToCalendarScreen()
	}
}

// MARK: - SetupUI

private extension EventsViewController {
	func setupUI() {
		navigationBarSetup()
		eventsCollectionViewSetup()
	}
	
	func navigationBarSetup() {
		let titleLabel = UILabel()
		titleLabel.attributedText = NSAttributedString(
			string: L10n.EventsScreen.title,
			attributes: [.font: UIFont.boldSystemFont(ofSize: Sizes.Font.title)]
			)
		titleLabel.sizeToFit()
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
	}
	
	func eventsCollectionViewSetup() {
		contentView.eventsCollectionView.delegate = self
		contentView.eventsCollectionView.dataSource = self
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension EventsViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		EventsViewModel.Sections.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let sectionType = EventsViewModel.Sections(rawValue: section) else {
			return .zero
		}
		switch sectionType {
		case .location:
			return 1
		case .dates:
			return 1
		case .category:
			return presenter.categories.count
		case .events:
			return presenter.events.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let sectionType = EventsViewModel.Sections(rawValue: indexPath.section) else {
			return UICollectionViewCell()
		}
		switch sectionType {
		case .location:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: LocationCell.identifier,
				for: indexPath
			) as? LocationCell else {
				return UICollectionViewCell()
			}
			cell.setLocationButton.addTarget(self, action: #selector(setLocationButtonTapped), for: .touchUpInside)
			cell.locationNameLabel.text = AllLocation.spb.description
			
			return cell
			
		case .category:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: CategoryCell.identifier,
				for: indexPath
			) as? CategoryCell else {
				return UICollectionViewCell()
			}
			let category = presenter.categories[indexPath.row]
			cell.configure(categoryName: category.name, isActive: category.isActive)
			
			return cell
			
		case .dates:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: DatesCell.identifier,
				for: indexPath
			) as? DatesCell else {
				return UICollectionViewCell()
			}
			cell.setDateButton.addTarget(self, action: #selector(setDateButtonTapped), for: .touchUpInside)
			cell.configure(dates: "C 13 июня")
			return cell
			
		case .events:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: EventViewCell.identifier,
				for: indexPath
			) as? EventViewCell else {
				return UICollectionViewCell()
			}
			let event = presenter.events[indexPath.row]
			
			cell.favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
			cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
			cell.configure(
				image: event.image,
				title: event.title,
				date: event.date,
				place: event.place,
				price: event.price, 
				isfavorite: event.isFavorite
			)
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let sectionType = EventsViewModel.Sections(rawValue: indexPath.section) else {
			return
		}
		switch sectionType {
		case.location:
			break
		case .category:
			presenter.categoryDidSelect(at: indexPath.item)
		case .dates:
			break
		case .events:
			presenter.routeToDetailsScreen(indexEvent: indexPath.item)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.item == presenter.events.count - 2 {
			presenter.fetchNextPage()
		}
	}
}

extension EventsViewController: UICollectionViewDelegate {
	
}

// MARK: - IEventListViewController

extension EventsViewController: IEventsView {
	func setLocation(_ location: String) {
		let indexPath = IndexPath(row: .zero, section: EventsViewModel.Sections.location.rawValue)
		guard let cell = contentView.eventsCollectionView.cellForItem(at: indexPath) as? LocationCell else { return }
		cell.locationNameLabel.text = location
	}
	
	func reloadEventsCollection() {
		contentView.eventsCollectionView.reloadData()
	}
	
	func addRowEventsCollection(startIndex: Int, endIndex: Int) {
		var indexPaths: [IndexPath] = []
		for index in startIndex...endIndex {
			indexPaths.append(IndexPath(item: index, section: EventsViewModel.Sections.events.rawValue))
		}
		contentView.eventsCollectionView.performBatchUpdates({
			contentView.eventsCollectionView.insertItems(at: indexPaths)
		}, completion: nil)
	}
	
	func reloadSection(_ section: Int) {
		contentView.eventsCollectionView.performBatchUpdates({
			let indexSet = IndexSet(integer: section)
			contentView.eventsCollectionView.reloadSections(indexSet)
		}, completion: nil)
	}
	
	func reloadCell(section: Int, cellIndex: Int) {
		let indexPath = IndexPath(row: cellIndex, section: section)
		contentView.eventsCollectionView.reloadItems(at: [indexPath])
	}
}
