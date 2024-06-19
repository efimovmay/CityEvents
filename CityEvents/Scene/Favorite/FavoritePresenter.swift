//
//  FavoritePresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import Foundation

protocol IFavoritePresenter {
	func viewIsReady(view: IFavoriteView)
	func reloadEvents()
	func getEventsCount() -> Int
	func getEventAtIndex(_ index: Int) -> EventModel
	func deleteEventTaped(at index: Int)
	func routeToDetailScreen(eventIndex: Int)
}

final class FavoritePresenter: IFavoritePresenter {
	// MARK: - Dependencies
	
	private weak var view: IFavoriteView?
	private let router: IFavoriteRouter
	private let storage: IEventsStorageService
	
	// MARK: - Private properties
	
	private var events: [EventModel] = []
	
	// MARK: - Initialization
	
	init(router: IFavoriteRouter, storage: IEventsStorageService) {
		self.router = router
		self.storage = storage
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IFavoriteView) {
		self.view = view
	}
	
	func reloadEvents() {
		events = []
		events = storage.getAllEvents().map { EventModel(from: $0) }
		if events.isEmpty {
			view?.hideTable()
		} else {
			view?.reloadFavoriteTable()
			view?.showTable()
		}
	}
	
	func getEventsCount() -> Int {
		return events.count
	}
	
	func getEventAtIndex(_ index: Int) -> EventModel {
		return events[index]
	}
	
	func deleteEventTaped(at index: Int) {
		storage.deleteEvent(withId: events[index].id)
		events.remove(at: index)
		view?.deleteRow(at: index)
	}
	
	func routeToDetailScreen(eventIndex: Int) {
		router.routeToDetailScreen(idEvent: events[eventIndex].id)
	}
}
