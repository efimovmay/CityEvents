//
//  LocationPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

protocol ILocationPresenter {
	func getLocationsCount() -> Int
	func getLocationAtIndex(_ index: Int) -> Locations
	func LocationSetDone(index: Int)
}

typealias SetLocationClosure = (Locations) -> Void

final class LocationPresenter: ILocationPresenter {
	
	private let router: IEventsRouter
	private let setLocationClosure: SetLocationClosure?
	
	private let locations = Locations.allCases
	
	init(router: IEventsRouter, setLocationClosure: SetLocationClosure?) {
		self.router = router
		self.setLocationClosure = setLocationClosure
	}
	
	func getLocationsCount() -> Int {
		locations.count
	}
	
	func getLocationAtIndex(_ index: Int) -> Locations {
		locations[index]
	}
	
	func LocationSetDone(index: Int) {
		setLocationClosure?(locations[index])
		router.dismissModalScreen()
	}
}
