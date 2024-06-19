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
	func favoriteButtonPressed(index: Int)
	func reloadAllFavoriteButton()
	func changeLocation()
	func changeDateEvents()
	func categoryDidSelect(at index: Int)
	func fetchNextPage()
	func routeToDetailsScreen(indexEvent: Int)
}

final class EventsPresenter: IEventsPresenter {
	
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let router: IEventsRouter
	private let network: INetworkService
	private let storage: IEventsStorageService
	
	var events: [EventsViewModel.Event] = .init()
	var categories: [EventsViewModel.Category] = .init()
	
	// MARK: - Private properties
	
	private let dateFormatter = DateFormatter()
	
	private var urlNextPage: String? = nil
	private var activeCaregory: Set<String> = .init()
	private var startDate: Date = .now
	private var endDate: Date?
	private var location: Locations = .spb
	
	// MARK: - Initialization
	
	init(router: IEventsRouter, network: INetworkService, storage: IEventsStorageService) {
		self.router = router
		self.network = network
		self.storage = storage
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
	
	func favoriteButtonPressed(index: Int) {
		if storage.eventExists(withId: events[index].eventInfo.id) {
			storage.deleteEvent(withId: events[index].eventInfo.id)
			reloadFavoriteButton(at: index)
		} else if index < events.count {
			storage.saveEvent(events[index].eventInfo)
			view?.changeFavoriteIcon(isFavorite: true, row: index)
		}
	}
	
	func reloadAllFavoriteButton() {
		events.enumerated().forEach { index, event in
			view?.changeFavoriteIcon(
				isFavorite: storage.eventExists(withId: events[index].eventInfo.id),
				row: index
			)
		}
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
		router.routeToDetailScreen(idEvent: events[indexEvent].eventInfo.id)
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
	
	func reloadFavoriteButton(at index: Int) {
		view?.changeFavoriteIcon(isFavorite: storage.eventExists(withId: events[index].eventInfo.id), row: index)
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
				text = "\(L10n.DatePrefix.from) \(startDateString) \(L10n.DatePrefix.toTime) \(endDateString)"
			}
		} else {
			text = "\(L10n.DatePrefix.from) \(startDateString)"
		}
		
		view?.setDateLabel(text: text)
		view?.reloadSection(EventsViewModel.Sections.dates.rawValue)
	}
	
	func addDownloadEvents(_ data: EventListDTO) {
		urlNextPage = data.next
		
		if data.results.isEmpty { return }
		let startIndex = self.events.count
		
		data.results.forEach { event in
			
			let dates = generateDatesString(from: event.dates)
			let lastDate = getLastDate(from: event.dates)
			let price = event.isFree ? L10n.DetailScreen.isFree : event.price.capitalized
			let images = event.images.map { $0.image }
			
			
			let event = EventsViewModel.Event(
				isFavorite: storage.eventExists(withId: event.id),
				eventInfo: EventModel(
					id: event.id,
					title: event.title.capitalized,
					dates: dates,
					price: price,
					address: event.place?.address,
					place: event.place?.title,
					description: decodeUnicodeString(event.description) ?? "",
					siteUrl: event.siteURL,
					images: images,
					lastDate: lastDate,
					shortTitle: event.shortTitle
				)
			)
			events.append(event)
		}
		
		let endIndex = self.events.count - 1
		DispatchQueue.main.async {
			self.view?.addRowEventsCollection(startIndex: startIndex, endIndex: endIndex)
		}
	}
	
	func fetchCategories() {
		network.fetch(
			dataType: [CategoriesEvent].self,
			with: NetworkRequestDataCategories()
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
				categories: getActiveCategory()
			)) { result in
				switch result {
				case .success(let data):
					self.addDownloadEvents(data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
}

// MARK: - Additional methods

private extension EventsPresenter {
	func getActiveCategory() -> String? {
		if activeCaregory.isEmpty {
			return nil
		} else {
			return activeCaregory.joined(separator: ",")
		}
	}
	
	func generateDatesString(from dates: [DateDetails]) -> String {
		var result: String = .init()
		dates.forEach { date in
			if date.endLess {
				result = L10n.DatePrefix.everyDay
				return
			}
			let startDate = Date(timeIntervalSince1970: date.start)
			let endDate = Date(timeIntervalSince1970: date.end)
			if endDate < .now { return }
			
			var dateString: String = ""
			if isSameDayAndMonth(firstDate: startDate, secondDate: endDate)  {
				dateString.append(dateFormatter.string(from: startDate))
			} else {
				dateString.append("\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))")
			}
			
			if let startTime = date.startTime, let endTime = date.endTime {
				dateString.append(", \(L10n.DatePrefix.startAt) \(startTime.dropLast(3)) \(L10n.DatePrefix.toTime) \(endTime.dropLast(3))")
			}
			if let startTime = date.startTime, date.endTime == nil {
				dateString.append(", \(L10n.DatePrefix.startAt) \(startTime.dropLast(3))")
			}
			if result.isEmpty {
				result = dateString
			} else {
				result.append("\n\(dateString)")
			}
		}
		return result
	}
	
	func isSameDayAndMonth(firstDate: Date, secondDate: Date) -> Bool {
		let calendar = Calendar.current
		let dateComponentsFirst = calendar.dateComponents([.day, .month], from: firstDate)
		let dateComponentsSecond = calendar.dateComponents([.day, .month], from: secondDate)
		
		return dateComponentsFirst.day == dateComponentsSecond.day &&
		dateComponentsFirst.month == dateComponentsSecond.month
	}
	
	func getLastDate(from dates: [DateDetails]) -> String {
		var isEveryDay = false
		var lastDate = Date(timeIntervalSince1970: dates.first!.end)
		
		dates.forEach { date in
			if date.endLess {
				isEveryDay = true
				return
			}
			if Date(timeIntervalSince1970: date.end) > lastDate  {
				lastDate = Date(timeIntervalSince1970: date.end)
			}
		}
		
		if isEveryDay {
			return L10n.DatePrefix.everyDay
		} else {
			return "\(L10n.DatePrefix.until) \(dateFormatter.string(from: lastDate))"
		}
	}
	
	func decodeUnicodeString(_ unicodeString: String) -> String? {
		guard let data = unicodeString.data(using: .utf8) else { return nil }
		
		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]
		guard let attributedString = try? NSAttributedString(
			data: data,
			options: options,
			documentAttributes: nil
		) else { return nil }
		return attributedString.string
	}
}
