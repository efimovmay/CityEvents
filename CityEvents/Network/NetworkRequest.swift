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
	var parameters: [String: String] { get set }
}


struct NetworkRequestDataEvents: INetworkRequestData {
	var path = NetworkEndpoints.commonPath.description + NetworkEndpoints.eventsPath.description
	var method = HTTPMethod.get
	var parameters: [String : String]
	
	init(location: AllLocation, actualSince: String? = nil, actualUntil: String? = nil) {

		parameters = [
			"fields" : "id,title,images,dates",
			"lang": "ru",
			"location": location.rawValue
		]
		if let actualSince = actualSince {
			parameters["actual_since"] = actualSince
		}
		if let actualUntil = actualUntil {
			parameters["actual_until"] = actualUntil
		}
	}
}
