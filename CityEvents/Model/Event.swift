//
//  Event.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

// MARK: - Event
struct EventDTO: Codable {
	let id: Int
	let dates: [DateRange]
	let title: String
	let place: Place
	let description: String
	let bodyText: String
	let location: Location
	let categories: [String]
	let ageRestriction: String
	let price: String
	let isFree: Bool
	let images: [EventImages]
	let favoritesCount: Int
	let commentsCount: Int
	let siteURL: String
	let shortTitle: String
	let tags: [String]
	let disableComments: Bool
	let participants: [Participant]
	
	enum CodingKeys: String, CodingKey {
		case id
		case dates
		case title
		case place
		case description
		case bodyText = "body_text"
		case location
		case categories
		case ageRestriction = "age_restriction"
		case price
		case isFree = "is_free"
		case images
		case favoritesCount = "favorites_count"
		case commentsCount = "comments_count"
		case siteURL = "site_url"
		case shortTitle = "short_title"
		case tags
		case disableComments = "disable_comments"
		case participants
	}
}

struct DateRange: Codable {
	let start: Int
	let end: Int
}

struct Place: Codable {
	let id: Int
}

struct Location: Codable {
	let slug: String
}

struct EventImages: Codable {
	let image: String
}

struct Participant: Codable {
	let id: Int
}