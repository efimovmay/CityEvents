//
//  DetailPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

protocol IDetailPresenter {
	var images: [String] { get }
	func viewIsReady(view: IDetailView)
	func openSite()
}

final class DetailPresenter: IDetailPresenter {
	// MARK: - Public properties
	
	var images: [String] = []
	
	// MARK: - Dependencies

	private weak var view: IDetailView?
	private let router: IDetailRouter
	private let network: INetworkService
	
	// MARK: - Private properties

	private let idEvent: Int
	private var siteUrl: String = ""
	
	// MARK: - Initialization
	
	init(router: IDetailRouter, network: INetworkService, idEvent: Int) {
		self.router = router
		self.network = network
		self.idEvent = idEvent
	}
	
	// MARK: - Public methods

	func viewIsReady(view: IDetailView) {
		self.view = view
		fetchEvent()
	}
	
	func openSite() {
		if let url = URL(string: siteUrl) {
			router.routeToSite(url: url)
		}
	}
}

// MARK: - Private methods

private extension DetailPresenter {
	func fetchEvent() {
		network.fetch(
			dataType: EventDTO.self,
			with: NetworkRequestDataDetailEvent(idEvent: idEvent, lang: "en")) { result in
				switch result {
				case .success(let data):
					self.makeViewModel(from: data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func makeViewModel(from data: EventDTO) {
		siteUrl = data.siteURL
		updateImagesCollection(data.images)
		
		let dates = generateDatesString(from: data.dates)
		let price = data.isFree ? L10n.DetailScreen.isFree : data.price.capitalized

		var address: String? = nil
		if let place =  data.place {
			address = ("\(place.title.capitalized)\n\(place.address)")
		}
		
		let viewModel = DetailViewModel(
			isFavorite: false,
			title: data.title.capitalized,
			dates: dates,
			price: price,
			address: address,
			description: decodeUnicodeString(data.description)
		)
		updateData(with: viewModel)
	}
	
	func updateImagesCollection(_ images: [EventImages]) {
		images.forEach { image in
			self.images.append(image.image)
		}
		DispatchQueue.main.async {
			self.view?.reloadImagesCollection()
		}
	}
	
	func updateData(with viewModel: DetailViewModel) {
		DispatchQueue.main.async {
			self.view?.render(viewModel: viewModel)
		}
	}

}

// MARK: - Additional methods

private extension DetailPresenter {
	
	func generateDatesString(from dates: [DateDetails]) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		dateFormatter.timeZone = .gmt
		
		var result: String = .init()
		dates.forEach { date in
			if date.endLess {
				result = L10n.DetailScreen.everyDay
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
				dateString.append(", c \(startTime.dropLast(3)) по \(endTime.dropLast(3))")
			}
			if let startTime = date.startTime, date.endTime == nil {
				dateString.append(", \(L10n.DetailScreen.startAt) \(startTime.dropLast(3))")
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
