//
//  Event.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

struct EventDTO: Decodable {
	let id: Int
	let dates: [DateDetails]
	let title: String
	let place: Place?
	let description: String
	let ageRestriction: StringOrInt?
	let price: String
	let isFree: Bool
	let images: [EventImages]
	let favoritesCount: Int
	let commentsCount: Int
	let siteUrl: String
	let shortTitle: String
	let tags: [String]
}

struct DateDetails: Decodable {
	let start: Double
	let end: Double
	let startTime: String?
	let endTime: String?
	let isEndless: Bool
	let schedules: [Schedules]
}

struct Schedules: Decodable {
	let daysOfWeek: [Int?]
	let startTime: String?
	let endTime: String?
}

struct Place: Decodable {
	let id: Int
	let title: String
	let address: String
	let subway: String?
	let coords: Coords
}

struct EventImages: Decodable {
	let image: String
}

struct Coords: Decodable {
	let lat: Double
	let lon: Double
}
