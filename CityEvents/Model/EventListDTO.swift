//
//  EventList.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

struct EventListDTO: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [EventDTO]
}
