//
//  EventsPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

protocol IEventsPresenter {
	func viewIsReady(view: IEventsView)
}

final class EventsPresenter: IEventsPresenter {
	
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let network: INetworkService
	private let router: EventsRouter
	// MARK: - Private properties
	
	// MARK: - Initialization
	
	init(router: EventsRouter, network: INetworkService) {
		self.network = network
		self.router = router
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		fetchEvent()
	}
}

private extension EventsPresenter {
	func fetchEvents() {
		network.fetch(
			dataType: EventListDTO.self,
			with: NetworkRequestDataEvents(
				location: AllLocation.spb,
				actualSince: String(Date().timeIntervalSince1970))
		) { result in
			switch result {
			case .success(let data):
				DispatchQueue.main.async {
					self.render(with: data)
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func fetchEventsOfDay() {
		network.fetch(
			dataType: EventOfDayDTO.self,
			with: NetworkRequestDataOfDay(
				location: AllLocation.spb
		)) { result in
			switch result {
			case .success(let data):
				DispatchQueue.main.async {
					self.render(with: data)
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func fetchEvent() {
		network.fetch(
			dataType: EventDTO.self,
			with: NetworkRequestDataDetailEvent(ids: 194980)
			) { result in
				switch result {
				case .success(let data):
					DispatchQueue.main.async {
						print(data.bodyText)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func render(with events: EventOfDayDTO) {
//		var list = EventsViewModel(eventList: [])
//		events.results.forEach { event in
//			list.eventList.append(EventsViewModel.Model(
//				title: event.object.title,
//				image: event.object.poster.image
//			))
//		}
//		view?.render(viewModel: list)
	}
	
	func render(with events: EventListDTO) {
		var list = EventsViewModel(eventList: [])
		events.results.forEach { event in
			list.eventList.append(EventsViewModel.Model(
				title: event.title,
				image: event.images[0].image
			))
		}
		view?.render(viewModel: list)
	}
}
