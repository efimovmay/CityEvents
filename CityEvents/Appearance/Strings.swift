//
//  Strings.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import Foundation

enum L10n {
	static let location = "location"
	
	enum Common {
		static let done = NSLocalizedString("common.done", comment: "")
		static let cancel = NSLocalizedString("common.cancel", comment: "")
	}
	enum CalendarScreen {
		static let title = NSLocalizedString("calendarScreen.title", comment: "")
	}
	
	enum EventsScreen {
		static let title = NSLocalizedString("eventsScreen.title", comment: "")
		static let until = NSLocalizedString("eventsScreen.until", comment: "")
		static let from = NSLocalizedString("eventsScreen.from", comment: "")
		static let to = NSLocalizedString("eventsScreen.to", comment: "")
		static let setDateTitle = NSLocalizedString("eventsScreen.set", comment: "")
	}
	
	enum Location {
		static let bg = NSLocalizedString("location.bg", comment: "")
		static let ekb = NSLocalizedString("location.ekb", comment: "")
		static let kev = NSLocalizedString("location.kev", comment: "")
		static let krasnoyarsk = NSLocalizedString("location.krasnoyarsk", comment: "")
		static let krd = NSLocalizedString("location.krd", comment: "")
		static let kzn = NSLocalizedString("location.kzn", comment: "")
		static let msk = NSLocalizedString("location.msk", comment: "")
		static let newYork = NSLocalizedString("location.newYork", comment: "")
		static let nnv = NSLocalizedString("location.nnv", comment: "")
		static let nsk = NSLocalizedString("location.nsk", comment: "")
		static let smr = NSLocalizedString("location.smr", comment: "")
		static let sochi = NSLocalizedString("location.sochi", comment: "")
		static let spb = NSLocalizedString("location.spb", comment: "")
		static let ufa = NSLocalizedString("location.ufa", comment: "")
	}
}
