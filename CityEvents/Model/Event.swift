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
	let publicationDate: Int
	let dates: [DateElement]
	let title: String
	let 	slug: String
	let place: Place
	let description, bodyText: String
	let location: Location
	let categories: [String]
	let tagline, ageRestriction, price: String
	let isFree: Bool
	let images: [Image]
	let favoritesCount, commentsCount: Int
	let siteURL: String
	let shortTitle: String
	let tags: [String]
	let disableComments: Bool
	let participants: [Participant]
	
	enum CodingKeys: String, CodingKey {
		case id
		case publicationDate = "publication_date"
		case dates, title, slug, place
		case description
		case bodyText = "body_text"
		case location, categories, tagline
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

// MARK: - DateElement
struct DateElement: Codable {
	let start, end: Int
}

// MARK: - Place
struct Place: Codable {
	let id: Int
}

// MARK: - Location
struct Location: Codable {
	let slug: String
}

// MARK: - Image
struct Image: Codable {
	let image: String
	let source: Source
}

// MARK: - Source
struct Source: Codable {
	let link, name: String
}

// MARK: - Participant
struct Participant: Codable {
	let role: Role
	let agent: Agent
}

// MARK: - Agent
struct Agent: Codable {
	let id: Int
	let title, slug, agentType: String
	let images: [String]
	let siteURL: String
	
	enum CodingKeys: String, CodingKey {
		case id, title, slug
		case agentType = "agent_type"
		case images
		case siteURL = "site_url"
	}
}

// MARK: - Role
struct Role: Codable {
	let slug: String
}
