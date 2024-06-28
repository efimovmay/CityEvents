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
	func loadImage(from url: String?, index: Int)
}

final class DetailPresenter: IDetailPresenter {
	// MARK: - Dependencies

	private weak var view: IDetailView?
	private let router: IDetailRouter
	private let network: INetworkService
	private let storage: IEventsStorageService
	private let imageService: IImageLoadService
	
	// MARK: - Private properties

	private let idEvent: Int
	private var viewModel: DetailViewModel?
	
	// MARK: - Initialization
	
	init(
		router: IDetailRouter,
		network: INetworkService,
		storage: IEventsStorageService,
		imageService: IImageLoadService,
		idEvent: Int
	) {
		self.router = router
		self.network = network
		self.storage = storage
		self.imageService = imageService
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
			storage.deleteEvent(withId: idEvent) { [weak self] success in
				guard success else { return }
				DispatchQueue.main.async {
					self?.view?.changeFavoriteIcon(isFavorite: false)
				}
			}
		} else {
			guard let viewModel = viewModel else { return }
			storage.saveEvent(viewModel.eventInfo) { [weak self] success in
				guard success else { return }
				DispatchQueue.main.async {
					self?.view?.changeFavoriteIcon(isFavorite: true)
				}
			}
		}
	}
	
	func loadImage(from url: String?, index: Int) {
		guard let url = url else { return }
		imageService.fetchImage(at: url) { dataImage in
			DispatchQueue.main.async {
				self.view?.setImage(dataImage: dataImage, indexItem: index)
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
			with: NetworkRequestDataDetailEvent(idEvent: idEvent)) { [weak self] result in
				switch result {
				case .success(let data):
					self?.makeViewModel(from: data)
				case .failure(let error):
					DispatchQueue.main.asyncAndWait {
						self?.view?.showDownloadEnd()
						self?.router.showAlert(with: error.localizedDescription)
					}
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
