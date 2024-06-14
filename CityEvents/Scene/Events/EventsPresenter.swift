//
//  EventsPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

protocol IEventsPresenter {
	var events: [EventsViewModel.Event] { get }
	var categories: [EventsViewModel.Category] { get }
	func viewIsReady(view: IEventsView)
	func routeToDetailsScreen(indexEvent: Int)
	func routeToCalendarScreen()
	func categoryDidSelect(at index: Int)
	func fetchNextPage()
}

final class EventsPresenter: IEventsPresenter {
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let network: INetworkService
	private let router: EventsRouter
	
	// MARK: - Private properties
	
	private let dateFormatter = DateFormatter()
	
	var currentLocation: AllLocation
	var events: [EventsViewModel.Event] = []
	var categories: [EventsViewModel.Category] = []
	
	private var urlNextPage: String? = nil
	private var activeCaregory: Set<String> = .init()

	
	// MARK: - Initialization
	
	init(router: EventsRouter, network: INetworkService) {
		self.network = network
		self.router = router
		self.currentLocation = AllLocation.spb
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		fetchCategories()
		fetchEvents()
	}
	
	func categoryDidSelect(at index: Int) {
		categories[index].isActive.toggle()
		view?.reloadCell(section: EventsViewModel.Sections.category.rawValue, cellIndex: index)
		
		if categories[index].isActive {
			activeCaregory.insert(categories[index].slug)
		} else {
			activeCaregory.remove(categories[index].slug)
		}
		events = []
		reloadSection(.events)
		fetchEvents()
	}
	
	func routeToDetailsScreen(indexEvent: Int) {
		router.routeToDetailScreen(idEvent: events[indexEvent].id)
	}
	
	func routeToCalendarScreen() {
		router.routeToCalendarScreen()
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
		network.fetch(dataType: [CategoriesEvent].self, with: NetworkRequestDataCategories(lang: "ru")) { result in
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
	
	func fetchEvents() {
		network.fetch(
			dataType: EventListDTO.self,
			with: NetworkRequestDataEvents(
				location: AllLocation.spb,
				actualSince: Date().timeIntervalSince1970,
				categories: getActiveCategory(),
				lang: "ru"
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
		guard !data.results.isEmpty else { return }
		
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
		let stringLastDate = "\(L10n.EventsScreen.until) \(String(dateFormatter.string(from: lastDate)))"
		
		return stringLastDate
	}
	
	func getActiveCategory() -> String? {
		if activeCaregory.isEmpty {
			return nil
		} else {
			return activeCaregory.joined(separator: ",")
		}
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
