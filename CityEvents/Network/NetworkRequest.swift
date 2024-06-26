//
//  NetworkRequest.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

/// Протокол для создания сетевых запросов.
protocol INetworkRequestData {
	/// Путь запроса.
	var path: String { get }
	/// HTTP Метод, указывающий тип запроса.
	var method: HTTPMethod { get }
	/// Параметры запроса.
	var parameters: [String: String] { get }
}

struct NetworkRequestDataCategories: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventCategories.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(lang: String = "ru") {
		parameters = [
			"lang" : lang
		]
	}
}

struct NetworkRequestDataEvents: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventsPath.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(
		location: Locations,
		actualSince: Double? = nil,
		actualUntil: Double? = nil,
		categories: String? = nil,
		lang: String = "ru"
	) {
		parameters = [
			"expand" : "place,dates",
			"fields" : "id,dates,title,place,description,age_restriction,price,is_free,images,favorites_count,comments_count,site_url,short_title,tags",
			"lang" : lang,
			"location": location.rawValue,
		]
		if let actualSince = actualSince {
			parameters["actual_since"] = String(actualSince)
		}
		if let actualUntil = actualUntil {
			parameters["actual_until"] = String(actualUntil)
		}
		if let categories = categories {
			parameters["categories"] = categories
		}
	}
}

struct NetworkRequestDataDetailEvent: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventsPath.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(idEvent: Int, lang: String = "ru") {
		path.append("/\(String(idEvent))")
		parameters = [
			"expand" : "place,dates",
			"lang" : lang
		]
	}
}

struct NetworkRequestDataOfDay: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventsOfDay.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(location: Locations, page: Int = 1) {
		parameters = [
			"lang": "ru",
			"page" : String(page),
			"location": location.rawValue,
			"expand" : "Object"
		]
	}
}
