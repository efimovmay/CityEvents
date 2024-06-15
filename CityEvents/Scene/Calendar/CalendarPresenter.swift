//
//  CalendarPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import Foundation

protocol ICalendarPresenter {
	func dateSetDone(startDate: Date?, endDate: Date?)
}

typealias SetDateClosure = (Date?, Date?) -> Void

final class CalendarPresenter: ICalendarPresenter {
	
	private let router: IEventsRouter
	private let setDateClosure: SetDateClosure?
	
	init(router: IEventsRouter, setDateClosure: SetDateClosure?) {
		self.router = router
		self.setDateClosure = setDateClosure
	}
	
	func dateSetDone(startDate: Date?, endDate: Date?) {
		setDateClosure?(startDate, endDate)
		router.dismissModalScreen()
	}
}
