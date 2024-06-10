//
//  RequestParameters.swift
//
//  Created by Aleksey Efimov on 05.06.2024.
//

import Foundation

struct EventQueryParameters {
	
	var fields: String?
	var pageSize: String?
	var location: String?
	var actualSince: String?
	
	var queryItems: [URLQueryItem] {
		var items = [URLQueryItem]()
		
		if let fields = fields {
			items.append(URLQueryItem(name: "fields", value: fields))
		}
		if let pageSize = pageSize {
			items.append(URLQueryItem(name: "page_size", value: pageSize))
		}
		if let location = location {
			items.append(URLQueryItem(name: "location", value: location))
		}
		if let actualSince = actualSince {
			items.append(URLQueryItem(name: "actual_since", value: actualSince))
		}
		return items
	}
	
	enum Default: String {
		case fields = "id,title,images,dates"
		case location = "spb"
		case pageSize = "20"
	}
}

enum RequestParameters: String {
	case clientId = "client_id"
	case query = "query"
}
