//
//  EventsViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

enum EventsViewModel {
	
	struct eventList {
		var eventList: [EventModel]
	}

	struct eventsOfDay {
		var eventOfDay: [EventModel]
	}
	
	struct EventModel {
		let title: String
		let image: String
		let price: String
		let place: String?
		let date: String?
	}
}
