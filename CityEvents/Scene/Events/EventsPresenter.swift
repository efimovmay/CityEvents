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
	
	private let dateFormatter = DateFormatter()

	// MARK: - Initialization
	
	init(router: EventsRouter, network: INetworkService) {
		self.network = network
		self.router = router
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		fetchEventsOfDay()
		fetchEvents()
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
					self.renderEventOfDay(with: data)
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
	
	func renderEventOfDay(with events: EventOfDayDTO) {
//		var list = EventsViewModel.eventsOfDay(eventOfDay: [])
//		events.results.forEach { event in
//			list.eventOfDay.append(EventsViewModel.Model(
//				title: event.object.,
//				image: event.object.
//			))
//		}
//		view?.renderEventOfDay(viewModel: list)
	}
	
	func render(with events: EventListDTO) {
		var list = EventsViewModel.eventList(eventList: [])
		events.results.forEach { event in
			list.eventList.append(EventsViewModel.EventModel(
				title: event.title.capitalizingFirstLetter(),
				image: event.images[0].image,
				price: event.price,
				place: event.place?.title,
				date: getLastDate(dateRange: event.dates)
			))
		}
		view?.renderEvents(viewModel: list)
	}
}

private extension EventsPresenter {
	func getLastDate(dateRange: [DateRange]) -> String? {
		guard let date = dateRange.last?.end else { return nil }
		let lastDate = Date(timeIntervalSince1970: date)
		let currentDate = Date()
		guard let dateBeforeYear = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) else { return nil }
		if lastDate <= currentDate || lastDate > dateBeforeYear { return nil }
		dateFormatter.dateStyle = .medium
		dateFormatter.locale = Locale.current
		let stringLastDate = "до \(String(dateFormatter.string(from: lastDate)))"
		return stringLastDate
	}
}
