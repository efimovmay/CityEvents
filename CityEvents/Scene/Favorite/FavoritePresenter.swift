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
	func loadImage(from url: String?, index: Int)
}

final class FavoritePresenter: IFavoritePresenter {
	// MARK: - Dependencies
	
	private weak var view: IFavoriteView?
	private let router: IFavoriteRouter
	private let storage: IEventsStorageService
	private let imageService: IImageLoadService
	
	// MARK: - Private properties
	
	private var events: [EventModel] = []
	
	// MARK: - Initialization
	
	init(router: IFavoriteRouter, storage: IEventsStorageService, imageService: IImageLoadService) {
		self.router = router
		self.storage = storage
		self.imageService = imageService
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IFavoriteView) {
		self.view = view
	}
	
	func reloadEvents() {
		events = []
		storage.getAllEvents() { [weak self] events in
			self?.events = events.map { EventModel(from: $0) }
			self?.showEvents()
		}
	}
	
	func getEventsCount() -> Int {
		return events.count
	}
	
	func getEventAtIndex(_ index: Int) -> EventModel {
		return events[index]
	}
	
	func deleteEventTaped(at index: Int) {
		storage.deleteEvent(withId: events[index].id) { [weak self] success in
			guard success else { return }
			self?.events.remove(at: index)
			DispatchQueue.main.async {
				self?.view?.deleteRow(at: index)
			}
		}
	}
	
	func routeToDetailScreen(eventIndex: Int) {
		router.routeToDetailScreen(idEvent: events[eventIndex].id)
	}
	
	func loadImage(from url: String?, index: Int) {
		guard let url = url else { return }
		imageService.fetchImage(at: url) { dataImage in
			DispatchQueue.main.async {
				self.view?.setImage(dataImage: dataImage, indexRow: index)
			}
		}
	}
}

private extension FavoritePresenter {
	func showEvents() {
		DispatchQueue.main.async {
			if self.events.isEmpty {
				self.view?.hideTable()
			} else {
				self.view?.reloadFavoriteTable()
				self.view?.showTable()
			}
		}
	}
}
