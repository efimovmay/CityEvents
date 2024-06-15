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
	func changeLocation()
	func changeDateEvents()
	func categoryDidSelect(at index: Int)
	func fetchNextPage()
	func routeToDetailsScreen(indexEvent: Int)
}

final class EventsPresenter: IEventsPresenter {
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let network: INetworkService
	private let router: IEventsRouter
	
	var events: [EventsViewModel.Event] = []
	var categories: [EventsViewModel.Category] = []
	
	// MARK: - Private properties
	
	private let dateFormatter = DateFormatter()

	private var urlNextPage: String? = nil
	private var activeCaregory: Set<String> = .init()
	private var startDate: Date = .now
	private var endDate: Date?
	private var location: Locations = .spb
	
	// MARK: - Initialization
	
	init(router: IEventsRouter, network: INetworkService) {
		self.network = network
		self.router = router
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		if let savedLocation: Locations = UserDefaults.standard.enumValue(forKey: L10n.KeyUserDefault.savedLocation) {
			location = savedLocation
		}
		changeDateLabel()
		changeLocationLabel()
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
	
	func changeLocation() {
		router.routeToLocationScreen { location in
			if location == self.location { return }
			self.location = location
			self.changeLocationLabel()
			self.reloadEvents()
		}
	}
	
	func changeDateEvents() {
		router.routeToCalendarScreen { startDate, endDate in
			if let startDate = startDate {
				self.startDate = startDate
				
				if let endDate = endDate {
					self.endDate = endDate
				} else {
					self.endDate = startDate.addingTimeInterval(23 * 60 * 60)
				}
			} else {
				self.startDate = .now
				self.endDate = nil
			}
			self.changeDateLabel()
			self.reloadEvents()
		}
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
	func reloadEvents() {
		events = []
		view?.reloadSection(EventsViewModel.Sections.events.rawValue)
		fetchEvents()
	}
	
	func reloadSection(_ section: EventsViewModel.Sections) {
		DispatchQueue.main.async {
			self.view?.reloadSection(section.rawValue)
		}
	}
	
	func changeLocationLabel() {
		view?.setLocationLabel(text: "\(L10n.EventsScreen.title)\n\(location.description)")
		view?.reloadSection(EventsViewModel.Sections.location.rawValue)
	}
	
	func changeDateLabel() {
		var text: String = ""
	
		dateFormatter.dateFormat = "dd MMMM"
		dateFormatter.timeZone = .gmt
		let startDateString = dateFormatter.string(from: startDate)
		
		if let endDate = endDate {
			let calendar = Calendar.current
			let componenetStartDate = calendar.dateComponents(in: .gmt, from: startDate)
			let componenetEndDate = calendar.dateComponents(in: .gmt, from: endDate)
			
			if componenetStartDate.day == componenetEndDate.day &&
				componenetStartDate.month == componenetEndDate.month {
				text = "\(startDateString)"
				
			} else if componenetStartDate.day != componenetEndDate.day &&
						componenetStartDate.month == componenetEndDate.month {
				dateFormatter.dateFormat = "dd"
				let startDay = dateFormatter.string(from: startDate)
				let endDay = dateFormatter.string(from: endDate)
				dateFormatter.dateFormat = "MMMM"
				let mounth = dateFormatter.string(from: startDate)
				text = "\(startDay) - \(endDay) \(mounth)"
				
			} else {
				let endDateString = dateFormatter.string(from: endDate)
				text = "\(L10n.EventsScreen.from) \(startDateString) \(L10n.EventsScreen.to) \(endDateString)"
			}
		} else {
			text = "\(L10n.EventsScreen.from) \(startDateString)"
		}

		view?.setDateLabel(text: text)
		view?.reloadSection(EventsViewModel.Sections.dates.rawValue)
	}
	
	func addDownloadEvents(_ data: EventListDTO) {
		urlNextPage = data.next
		if data.results.isEmpty { return }
		
		let startIndex = self.events.count
		data.results.forEach { event in
			self.events.append(EventsViewModel.Event(
				id: event.id,
				title: event.title.capitalizingFirstLetter(),
				image: event.images[.zero].image,
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
	
	func fetchCategories() {
		network.fetch(
			dataType: [CategoriesEvent].self,
			with: NetworkRequestDataCategories(lang: "ru")
		) { result in
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
				location: location,
				actualSince: startDate.timeIntervalSince1970,
				actualUntil: endDate?.timeIntervalSince1970,
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
}
