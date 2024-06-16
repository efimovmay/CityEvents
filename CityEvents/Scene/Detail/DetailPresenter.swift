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
					self.makeViewModel(from: data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func makeViewModel(from data: EventDTO) {
		var images: [String] = []
		data.images.forEach { image in
			images.append(image.image)
		}
		
		let viewModel = DetailViewModel(
			images: images,
			isFavorite: false,
			title: data.title,
			date: generateDatesString(from: data.dates),
			namePlace: data.place?.title,
			address: data.place?.address,
			description: decodeUnicodeString(data.description),
			urlEvent: data.siteURL
		)
		renderData(viewModel: viewModel)
	}
	
	func renderData(viewModel: DetailViewModel) {
		DispatchQueue.main.async {
			self.view?.render(viewModel: viewModel)
		}
	}
	
	func generateDatesString(from dates: [DateDetails]) -> [String] {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		dateFormatter.timeZone = .gmt
		
		var result: [String] = []
		dates.forEach { date in
			if date.endLess {
				result = [L10n.DetailScreen.everyDay]
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
			result.append(dateString)
			
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
