//
//  FavoritePresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import Foundation

protocol IFavoritePresenter {
	func viewIsReady(view: IFavoriteView)

}

final class FavoritePresenter: IFavoritePresenter {
	// MARK: - Dependencies
	
	private weak var view: IFavoriteView?
	private let router: IFavoriteRouter
	private let storage: IEventsStorageService
	
	// MARK: - Private properties
	
	private var eventModel: EventModel?
	
	// MARK: - Initialization
	
	init(router: IFavoriteRouter, storage: IEventsStorageService) {
		self.router = router
		self.storage = storage
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IFavoriteView) {
		self.view = view
	}
}
