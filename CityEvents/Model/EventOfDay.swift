//
//  EventOfDay.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

struct EventOfDayDTO: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [Results]
	
	struct Results: Decodable {
		let object: MovieObject
	}
	
	struct MovieObject: Decodable {
		let id: Int
	}
}
