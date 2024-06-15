//
//  DetailPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

protocol IDetailPresenter {
	func viewIsReady(view: IDetailView)
}

final class DetailPresenter: IDetailPresenter {
	
	private weak var view: IDetailView?
	private let router: IDetailRouter
	private let network: INetworkService
	private let idEvent: Int
	
	init(router: IDetailRouter, network: INetworkService, idEvent: Int) {
		self.router = router
		self.network = network
		self.idEvent = idEvent
	}
	
	func viewIsReady(view: IDetailView) {
		self.view = view
		fetchEvent()
	}
}

private extension DetailPresenter {
	func fetchEvent() {
		network.fetch(
			dataType: EventDTO.self,
			with: NetworkRequestDataDetailEvent(idEvent: idEvent)) { result in
				switch result {
				case .success(let data):
					print(data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
}
