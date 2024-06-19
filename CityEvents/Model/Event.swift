//
//  Event.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import Foundation

struct EventModel {
	let id: Int
	let title: String
	var dates: String
	let price: String
	let address: String?
	let place: String?
	var description: String
	let siteUrl: String
	let images: [String]
	var lastDate: String
	let shortTitle: String
}

extension EventModel {
	init(from model: EventData) {
		self.id = Int(model.id)
		self.title = model.title
		self.dates = model.dates
		self.price = model.price
		self.place = model.place
		self.address = model.address
		self.siteUrl = model.siteURL
		self.description = model.body
		self.images = model.images ?? []
		self.lastDate = model.lastDate
		self.shortTitle = model.shortTitle
	}
}

extension EventModel {
	init(from model: EventDTO) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		dateFormatter.timeZone = .gmt
		
		self.id = model.id
		self.title = model.title.capitalized
		self.dates = ""
		self.price = model.isFree ? L10n.DetailScreen.isFree : model.price.capitalized
		self.address = model.place?.address
		self.place = model.place?.title
		self.description = ""
		self.siteUrl = model.siteURL
		self.images = model.images.map { $0.image }
		self.lastDate = ""
		self.shortTitle = model.shortTitle
		
		self.dates = generateDatesString(from: model.dates, dateFormatter: dateFormatter)
		self.description = decodeUnicodeString(model.description) ?? ""
		self.lastDate = getLastDate(from: model.dates, dateFormatter: dateFormatter)
	}
	
	private func generateDatesString(from dates: [DateDetails], dateFormatter: DateFormatter) -> String {
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
	
	private func isSameDayAndMonth(firstDate: Date, secondDate: Date) -> Bool {
		let calendar = Calendar.current
		let dateComponentsFirst = calendar.dateComponents([.day, .month], from: firstDate)
		let dateComponentsSecond = calendar.dateComponents([.day, .month], from: secondDate)
		
		return dateComponentsFirst.day == dateComponentsSecond.day &&
		dateComponentsFirst.month == dateComponentsSecond.month
	}
	
	private func decodeUnicodeString(_ unicodeString: String) -> String? {
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
	
	private func getLastDate(from dates: [DateDetails], dateFormatter: DateFormatter) -> String {
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
}
