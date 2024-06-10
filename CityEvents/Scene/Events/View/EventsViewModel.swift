//
//  EventsViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

struct EventsViewModel {
	var eventList: [Model]
	
	struct Model {
		let title: String
		let image: String
	}
}
