//
//  EventsViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

enum EventsViewModel {
	
	enum Sections: Int, CaseIterable {
		case category
		case	 events
	}
	
	struct Category {
		let slug: String
		let name: String
	}
	
	struct Event {
		let id: Int
		let title: String
		let image: String
		let price: String
		let place: String?
		let date: String?
	}
}
