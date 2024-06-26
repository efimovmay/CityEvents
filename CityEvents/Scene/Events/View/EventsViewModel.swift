//
//  EventsViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

enum EventsViewModel {
	
	enum Sections: Int, CaseIterable {
		case location
		case dates
		case category
		case	 events
	}
	
	struct Category {
		let slug: String
		let name: String
		var isActive: Bool = false
	}
	
	struct Event {
		var isFavorite: Bool
		let event: EventModel
	}
}
