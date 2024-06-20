//
//  EventsPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

final class EventsPresenter {
	// MARK: - Public properties
	
	var events: [EventsViewModel.Event] = []
	var categories: [EventsViewModel.Category] = []
	
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	private let router: IEventsRouter
	private let network: INetworkService
	private let storage: IEventsStorageService
	private let imageService: IImageLoadService
	
	// MARK: - Private properties

	private var urlNextPage: String? = nil
	private var activeCaregory: Set<String> = .init()
	private var startDate: Date = .now
	private var endDate: Date?
	private var location: Locations = .spb
	
	// MARK: - Initialization
	
	init(router: IEventsRouter, network: INetworkService, storage: IEventsStorageService, imageService: IImageLoadService) {
		self.router = router
		self.network = network
		self.storage = storage
		self.imageService = imageService
	}
	
	// MARK: - Public methods
	
	func viewIsReady(view: IEventsView) {
		self.view = view
		if let savedLocation: Locations = UserDefaults.standard.enumValue(forKey: L10n.KeyUserDefault.savedLocation) {
			location = savedLocation
		}
		fetchCategories()
		fetchEvents()
	}
	
	func favoriteButtonPressed(index: Int) {
		if storage.eventExists(withId: events[index].event.id) {
			storage.deleteEvent(withId: events[index].event.id)
			reloadFavoriteButton(at: index)
		} else if index < events.count {
			storage.saveEvent(events[index].event)
			view?.changeFavoriteIcon(isFavorite: true, row: index)
		}
	}
	
	func reloadAllFavoriteButton() {
		events.enumerated().forEach { index, event in
			view?.changeFavoriteIcon(
				isFavorite: storage.eventExists(withId: events[index].event.id),
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
		reloadEvents()
	}
	
	func routeToDetailsScreen(indexEvent: Int) {
		router.routeToDetailScreen(idEvent: events[indexEvent].event.id)
	}
	
	func changeLocationButtonPressed() {
		router.routeToLocationScreen { location in
			if self.location == location { return }
			self.location = location
			self.view?.setLocationLabel(text: self.getLocationLabel())
			self.reloadEvents()
		}
	}
	
	func getLocationLabel() -> String {
		return "\(L10n.EventsScreen.title)\n\(location.description)"
	}
	
	func changeDateButtonPressed() {
		router.routeToCalendarScreen { [weak self] startDate, endDate in
			self?.setNewDate(start: startDate, end: endDate)
		}
	}
	
	func getDateLabel() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMMM"
		dateFormatter.timeZone = .gmt
		let startDateString = dateFormatter.string(from: startDate)
		
		if let endDate = endDate {
			let calendar = Calendar.current
			let componenetStartDate = calendar.dateComponents(in: .gmt, from: startDate)
			let componenetEndDate = calendar.dateComponents(in: .gmt, from: endDate)
			
			if componenetStartDate.day == componenetEndDate.day &&
				componenetStartDate.month == componenetEndDate.month {
				return "\(startDateString)"
				
			} else if componenetStartDate.day != componenetEndDate.day &&
						componenetStartDate.month == componenetEndDate.month {
				dateFormatter.dateFormat = "dd"
				let startDay = dateFormatter.string(from: startDate)
				let endDay = dateFormatter.string(from: endDate)
				dateFormatter.dateFormat = "MMMM"
				let mounth = dateFormatter.string(from: startDate)
				return "\(startDay) - \(endDay) \(mounth)"
				
			} else {
				let endDateString = dateFormatter.string(from: endDate)
				return "\(startDateString) - \(endDateString)"
			}
		} else {
			return "\(L10n.DatePrefix.from) \(startDateString)"
		}
	}
	
	func loadImage(from url: String?, index: Int) {
		guard let url = url else { return }
		imageService.fetchImage(at: url) { [weak self] dataImage in
			DispatchQueue.main.async {
				self?.view?.setImage(dataImage: dataImage, indexItem: index)
			}
		}
	}
	
	func fetchNextPage() {
		if let url = urlNextPage {
			network.fetch(dataType: EventListDTO.self, url: url) { [weak self] result in
				switch result {
				case .success(let data):
					self?.addDownloadEvents(data)
				case .failure(let error):
					DispatchQueue.main.asyncAndWait {
						self?.router.showAlert(with: error.localizedDescription)
					}
				}
			}
		}
	}
	
	func reloadEvents() {
		events = []
		reloadSection(.events)
		fetchEvents()
	}
}

private extension EventsPresenter {
	func reloadSection(_ section: EventsViewModel.Sections) {
		DispatchQueue.main.async {
			self.view?.reloadSection(section.rawValue)
		}
	}
	
	func reloadFavoriteButton(at index: Int) {
		view?.changeFavoriteIcon(
			isFavorite: storage.eventExists(withId: events[index].event.id),
			row: index
		)
	}
	
	func fetchCategories() {
		network.fetch(
			dataType: [CategoriesEvent].self,
			with: NetworkRequestDataCategories()
		) { [weak self] result in
			switch result {
			case .success(let data):
				data.forEach { category in
					self?.categories.append(EventsViewModel.Category(
						slug: category.slug,
						name: category.name
					))
				}
				self?.reloadSection(.category)
			case .failure(_):
				break
			}
		}
	}
	
	func fetchEvents() {
		view?.showStartDownload()
		network.fetch(
			dataType: EventListDTO.self,
			with: NetworkRequestDataEvents(
				location: location,
				actualSince: startDate.timeIntervalSince1970,
				actualUntil: endDate?.timeIntervalSince1970,
				categories: getActiveCategory()
			)) { [weak self] result in
				switch result {
				case .success(let data):
					self?.addDownloadEvents(data)
				case .failure(let error):
					DispatchQueue.main.asyncAndWait {
						self?.view?.showDownloadEnd()
						self?.router.showAlert(with: error.localizedDescription)
					}
				}
			}
	}
	
	func addDownloadEvents(_ data: EventListDTO) {
		urlNextPage = data.next
		
		if data.results.isEmpty { return }
		let startIndex = events.count
		data.results.forEach { event in
			events.append(EventsViewModel.Event(
				isFavorite: storage.eventExists(withId: event.id),
				event: EventModel(from: event)
			))
		}
		let endIndex = events.count - 1

		DispatchQueue.main.async {
			self.view?.showDownloadEnd()
			self.view?.addRowEventsCollection(startIndex: startIndex, endIndex: endIndex)
		}
	}
	
	func setNewDate(start: Date?, end: Date?) {
		if let newStartDate = start {
			startDate = newStartDate
			if let newEndDate = end {
				endDate = newEndDate
			} else {
				endDate = startDate.addingTimeInterval(23 * 60 * 60)
			}
		} else {
			startDate = .now
			endDate = nil
		}
		view?.setDateLabel(text: getDateLabel())
	}
	
	func getActiveCategory() -> String? {
		return activeCaregory.isEmpty ? nil : activeCaregory.joined(separator: ",")
	}
}
