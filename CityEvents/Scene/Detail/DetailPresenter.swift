//
//  DetailPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

protocol IDetailPresenter {
	func viewIsReady(view: IDetailView)
	func getImagesCount() -> Int
	func getImageAtIndex(_ index: Int) -> String
	func openSite()
	func favoriteButtonPressed()
}

final class DetailPresenter: IDetailPresenter {
	// MARK: - Dependencies

	private weak var view: IDetailView?
	private let router: IDetailRouter
	private let network: INetworkService
	private let storage: IEventsStorageService
	
	// MARK: - Private properties

	private let idEvent: Int
	private var viewModel: DetailViewModel?
	
	// MARK: - Initialization
	
	init(router: IDetailRouter, network: INetworkService, storage: IEventsStorageService, idEvent: Int) {
		self.router = router
		self.network = network
		self.storage = storage
		self.idEvent = idEvent
	}
	
	// MARK: - Public methods

	func viewIsReady(view: IDetailView) {
		self.view = view
		loadData()
	}
	
	func getImagesCount() -> Int {
		return viewModel?.eventInfo.images.count ?? .zero
	}
	
	func getImageAtIndex(_ index: Int) -> String {
		return viewModel?.eventInfo.images[index] ?? ""
	}
	
	func openSite() {
		if let viewModel = viewModel, let url = URL(string: viewModel.eventInfo.siteUrl) {
			router.routeToSite(url: url)
		}
	}
	
	func favoriteButtonPressed() {
		if storage.eventExists(withId: idEvent) {
			storage.deleteEvent(withId: idEvent)
			view?.changeFavoriteIcon(isFavorite: false)
		} else {
			if let viewModel = viewModel {
				storage.saveEvent(viewModel.eventInfo)
				view?.changeFavoriteIcon(isFavorite: true)
			}
		}
	}
}

// MARK: - Private methods

private extension DetailPresenter {
	
	func loadData() {
		if let event = storage.getEvent(withId: idEvent) {
			viewModel = DetailViewModel(isFavorite: true, eventInfo: EventModel(from: event))
			updateView()
		} else {
			fetchEvent()
		}
	}
	
	func fetchEvent() {
		network.fetch(
			dataType: EventDTO.self,
			with: NetworkRequestDataDetailEvent(idEvent: idEvent)) { result in
				switch result {
				case .success(let data):
					self.makeViewModel(from: data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func makeViewModel(from data: EventDTO) {
		viewModel = DetailViewModel(
			isFavorite: storage.eventExists(withId: idEvent),
			eventInfo: EventModel(from: data)
		)
		updateView()
	}
	
	func updateView() {
		guard let viewModel = viewModel else { return }
		
		DispatchQueue.main.async {
			self.view?.reloadImagesCollection()
			self.view?.render(viewModel: viewModel)
		}
	}
}
