//
//  EventsViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

protocol IEventsView: AnyObject {
	func renderEvents(viewModel: EventsViewModel.eventList)
	func renderEventOfDay(viewModel: EventsViewModel.eventsOfDay)
}

final class EventsViewController: UIViewController {
	// MARK: - Dependencies
	
	private let presenter: IEventsPresenter
	
	// MARK: - Private properties
	

	private lazy var contentView: EventsView = EventsView()
	private var events: EventsViewModel.eventList = .init(eventList: [])
	private var eventOfDay: EventsViewModel.eventsOfDay = .init(eventOfDay: [])
	
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
	func likeButtonTapped(_ sender: UIButton) {
		sender.isSelected.toggle()
		
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
			return eventOfDay.eventOfDay.count
			
		case .regular:
			return events.eventList.count
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
			let event = eventOfDay.eventOfDay[indexPath.row]
			cell.configure(image: event.image, name: event.title)
			
			return cell
			
		case .regular:
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: RegularEventViewCell.identifier,
				for: indexPath
			) as? RegularEventViewCell else {
				return UICollectionViewCell()
			}
			
			let event = events.eventList[indexPath.row]
			cell.configure(
				image: event.image,
				title: event.title,
				date: event.date,
				place: event.place,
				price: event.price
			)
			cell.favoriteButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
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
}

extension EventsViewController: UICollectionViewDelegate {
	
}

// MARK: - IEventListViewController

extension EventsViewController: IEventsView {
	func renderEvents(viewModel: EventsViewModel.eventList) {
		events = viewModel
		contentView.eventsCollectionView.reloadData()
	}
	
	func renderEventOfDay(viewModel: EventsViewModel.eventsOfDay) {
		eventOfDay = viewModel
		contentView.eventsCollectionView.reloadData()
	}
}
