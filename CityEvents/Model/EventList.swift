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
	let results: [Event]
	
	struct Event: Decodable {
		let id: Int
		let dates: [DateRange]
		let title: String
		let place: Place?
		let price: String
		let images: [EventImages]
	}
}
