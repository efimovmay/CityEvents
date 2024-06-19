//
//  EventModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import Foundation

struct EventModel {
	let id: Int
	let title: String
	let dates: String
	let price: String
	let address: String?
	let place: String?
	let description: String
	let siteUrl: String
	let images: [String]
	let lastDate: String
}

extension EventModel {
	init(event: Event) {
		self.id = Int(event.id)
		self.title = event.title
		self.dates = event.dates
		self.price = event.price
		self.place = event.place
		self.address = event.address
		self.siteUrl = event.siteURL
		self.description = event.body
		self.images = event.images ?? []
		self.lastDate = event.lastDate
	}
}
