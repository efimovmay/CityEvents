//
//  EventOfDay.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

struct EventOfDayDTO: Codable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [Results]
	
	struct Results: Codable {
		let object: MovieObject
	}
	
	struct MovieObject: Codable {
		let id: Int
	}
}
