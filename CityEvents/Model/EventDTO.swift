//
//  Event.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

// MARK: - Event
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
	let siteURL: String
	let shortTitle: String
	let tags: [String]
	
	enum CodingKeys: String, CodingKey {
		case id
		case dates
		case title
		case place
		case description
		case ageRestriction = "age_restriction"
		case price
		case isFree = "is_free"
		case images
		case favoritesCount = "favorites_count"
		case commentsCount = "comments_count"
		case siteURL = "site_url"
		case shortTitle = "short_title"
		case tags
	}
}

struct DateDetails: Decodable {
	let start: Double
	let end: Double
	let startTime: String?
	let endTime: String?
	let endLess: Bool
	let schedules: [Schedules]
	
	enum CodingKeys: String, CodingKey {
		case start, end
		case startTime = "start_time"
		case endTime = "end_time"
		case endLess = "is_endless"
		case schedules
	}
}

struct Schedules: Decodable {
	let dayOfWeak: [Int?]
	let startTime: String?
	let endTime: String?
	
	enum CodingKeys: String, CodingKey {
		case dayOfWeak = "days_of_week"
		case startTime = "start_time"
		case endTime = "end_time"
	}
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
