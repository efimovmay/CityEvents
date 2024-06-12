//
//  EventsPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

protocol IEventsPresenter {
	func viewIsReady(view: IEventsView)
	func numberOfCategory() -> Int
	func numberOfEvents() -> Int
	func getCategory(at index: Int) -> EventsViewModel.Category
	func getEvent(at index: Int) -> EventsViewModel.Event
	func routeToDetailsScreen(indexEvent: Int)
	func fetchEventsByCategory(at index: Int)
	func fetchNextPage()
}

final class EventsPresenter: IEventsPresenter {
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let network: INetworkService
	private let router: EventsRouter
	
	// MARK: - Private properties
	
	private let dateFormatter = DateFormatter()
	
	var events: [EventsViewModel.Event] = []
	var categories: [EventsViewModel.Category] = []
	
	private var urlNextPage: String? = nil
	
	// MARK: - Initialization
	
	init(router: EventsRouter, network: INetworkService) {
		self.network = network
		self.router = router
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		fetchCategories()
		fetchEvents(categories: nil)
	}
	
	func fetchEventsByCategory(at index: Int) {
		events = []
		reloadSection(.events)
		fetchEvents(categories: categories[index].slug)
	}
	
	func routeToDetailsScreen(indexEvent: Int) {
		router.routeToDetailScreen(idEvent: events[indexEvent].id)
	}
	
	func fetchNextPage() {
		if let url = urlNextPage {
			network.fetch(dataType: EventListDTO.self, url: url) { result in
				switch result {
				case .success(let data):
					self.addDownloadEvents(data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}

private extension EventsPresenter {
	
	func fetchCategories() {
		network.fetch(dataType: [CategoriesEvent].self, with: NetworkRequestDataCategories()) { result in
			switch result {
			case .success(let data):
				data.forEach { category in
					self.categories.append(EventsViewModel.Category(
						slug: category.slug,
						name: category.name
					))
				}
				self.reloadSection(.category)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func fetchEvents(categories: String?) {
		network.fetch(
			dataType: EventListDTO.self,
			with: NetworkRequestDataEvents(
				location: AllLocation.spb,
				actualSince: Date().timeIntervalSince1970,
				categories: categories
			)) { result in
				switch result {
				case .success(let data):
					self.addDownloadEvents(data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func addDownloadEvents(_ data: EventListDTO) {
		urlNextPage = data.next
		let startIndex = self.events.count
		
		data.results.forEach { event in
			self.events.append(EventsViewModel.Event(
				id: event.id,
				title: event.title.capitalizingFirstLetter(),
				image: event.images[0].image,
				price: event.price,
				place: event.place?.title,
				date: self.getLastDate(dateRange: event.dates)
			))
		}
		let endIndex = self.events.count - 1
		DispatchQueue.main.async {
			self.view?.addRowEventsCollection(startIndex: startIndex, endIndex: endIndex)
		}
	}
	
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
	
	func reloadEventsCollection() {
		DispatchQueue.main.async {
			self.view?.reloadEventsCollection()
		}
	}
	
	func reloadSection(_ section: EventsViewModel.Sections) {
		DispatchQueue.main.async {
			self.view?.reloadSection(section.rawValue)
		}
	}
}


//func fetchEvent() {
//	network.fetch(
//		dataType: EventDTO.self,
//		with: NetworkRequestDataDetailEvent(ids: 194980)
//	) { result in
//		switch result {
//		case .success(let data):
//			DispatchQueue.main.async {
//				print(data.bodyText)
//			}
//		case .failure(let error):
//			print(error.localizedDescription)
//		}
//	}
//	}
