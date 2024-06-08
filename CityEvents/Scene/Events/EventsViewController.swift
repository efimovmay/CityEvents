//
//  EventsViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

protocol IEventsView: AnyObject {
	func render(viewModel: EventsViewModel)
}

final class EventsViewController: UIViewController {
	// MARK: - Dependencies
	
	private let presenter: IEventsPresenter
	
	// MARK: - Private properties
	
	private lazy var contentView: EventsView = EventsView()
	private var viewModel: EventsViewModel = .init(eventList: [])
	
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

// MARK: - SetupUI

private extension EventsViewController {
	func setupUI() {
		navigationBarSetup()
		eventsCollectionViewSetup()
	}
	
	func navigationBarSetup() {
		title = "EVENTS"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	func eventsCollectionViewSetup() {
		contentView.eventsCollectionView.delegate = self
		contentView.eventsCollectionView.dataSource = self
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension EventsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: EventViewCell.identifier,
			for: indexPath
		) as? EventViewCell else {
			return UICollectionViewCell()
		}
		
		return cell
	}
}

extension EventsViewController: UICollectionViewDelegate {
	
}

// MARK: - IEventListViewController

extension EventsViewController: IEventsView {
	func render(viewModel: EventsViewModel) {
		self.viewModel = viewModel
	}
}
