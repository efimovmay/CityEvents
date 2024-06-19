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
	
	enum KeyUserDefault {
		static let savedLocation = "savedLocation"
	}
	
	enum TabBar {
		static let events = NSLocalizedString("tabBar.events", comment: "")
		static let favorite = NSLocalizedString("tabBar.favorite", comment: "")
	}
	
	enum DatePrefix {
		static let everyDay = NSLocalizedString("datePrefix.everyDay", comment: "")
		static let until = NSLocalizedString("datePrefix.until", comment: "")
		static let from = NSLocalizedString("datePrefix.from", comment: "")
		static let startAt = NSLocalizedString("datePrefix.startAt", comment: "")
		static let toTime = NSLocalizedString("datePrefix.toTime", comment: "")
	}
	
	enum CalendarScreen {
		static let title = NSLocalizedString("calendarScreen.title", comment: "")
	}
	
	enum LocationScreen {
		static let title = NSLocalizedString("locationScreen.title", comment: "")
	}
	
	enum FavoriteScreen {
		static let noEvents = NSLocalizedString("favoriteScreen.noEvents", comment: "")
	}
	
	enum DetailScreen {
		static let onSiteButtonTitle = NSLocalizedString("detailScreen.onSiteButtonTitle", comment: "")
		static let textDescriptionLabel = NSLocalizedString("detailScreen.textDescriptionLabel", comment: "")
		static let isFree = NSLocalizedString("detailScreen.isFree", comment: "")
	}
	
	enum EventsScreen {
		static let title = NSLocalizedString("eventsScreen.title", comment: "")
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
