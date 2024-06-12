//
//  NetworkEndpoints.swift
//
//  Created by Aleksey Efimov on 05.06.2024.
//

import Foundation

enum NetworkEndpoints {
	static let baseURL = "https://kudago.com"
	
	case commonPath
	case eventsOfDay
	case searchPath
	case eventsPath
	case listPath
	case placesPath
	case moviesPath
	case moviesShowingsPath
	case eventCategories
}

extension NetworkEndpoints: CustomStringConvertible {
	var description: String {
		switch self {
		case .commonPath:
			"/public-api/v1.4"
		case .searchPath:
			"/search"
		case .eventsPath:
			"/events"
		case .listPath:
			"/lists"
		case .placesPath:
			"/places"
		case .moviesPath:
			"/movies"
		case .moviesShowingsPath:
			"/movie-showings"
		case .eventsOfDay:
			"/events-of-the-day"
		case .eventCategories:
			"/event-categories"
		}
	}
}

