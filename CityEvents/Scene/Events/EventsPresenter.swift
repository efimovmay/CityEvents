//
//  EventsPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

protocol IEventsPresenter {
	func viewIsReady(view: IEventsView)
}

final class EventsPresenter: IEventsPresenter {
	
	// MARK: - Dependencies
	
	private weak var view: IEventsView?
	
	// MARK: - Private properties
	
	// MARK: - Initialization
	
	// MARK: - Public methods
	func viewIsReady(view: IEventsView) {
		self.view = view
	}
}
