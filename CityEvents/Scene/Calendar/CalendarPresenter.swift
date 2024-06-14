//
//  CalendarPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import Foundation

protocol ICalendarPresenter {
	func viewIsReady(view: ICalendarView)
}

final class CalendarPresenter: ICalendarPresenter {
	
	weak var view: ICalendarView?
	
	init() {}
	
	func viewIsReady(view: ICalendarView) {
		self.view = view
	}
}
