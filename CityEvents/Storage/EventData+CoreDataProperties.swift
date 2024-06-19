//
//  EventData+CoreDataProperties.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 19.06.2024.
//
//

import Foundation
import CoreData


extension EventData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventData> {
        return NSFetchRequest<EventData>(entityName: "EventData")
    }

	@NSManaged public var address: String?
	@NSManaged public var body: String
	@NSManaged public var dates: String
	@NSManaged public var id: Int64
	@NSManaged public var images: [String]?
	@NSManaged public var lastDate: String
	@NSManaged public var place: String?
	@NSManaged public var price: String
	@NSManaged public var siteURL: String
	@NSManaged public var title: String
	@NSManaged public var shortTitle: String

}

extension EventData : Identifiable {

}
