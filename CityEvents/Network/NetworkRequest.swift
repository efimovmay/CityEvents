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
	
	init(lang: String) {
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
		location: AllLocation,
		actualSince: Double? = nil,
		actualUntil: Double? = nil,
		categories: String? = nil,
		lang: String
	) {
		
		parameters = [
			"expand" : "place",
			"fields" : "id,dates,title,place,price,images",
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
	
	init(ids: Int) {
		path.append("/\(String(ids))")
		parameters = [
			"lang" : "ru"
		]
	}
}

struct NetworkRequestDataOfDay: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventsOfDay.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(location: AllLocation, page: Int = 1) {
		parameters = [
			"lang": "ru",
			"page" : String(page),
			"location": location.rawValue,
			"expand" : "Object"
		]
	}
}
