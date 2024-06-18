//
//  Event+CoreDataProperties.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var address: String?
    @NSManaged public var body: String?
    @NSManaged public var dates: String?
    @NSManaged public var id: Int64
    @NSManaged public var place: String?
    @NSManaged public var price: String?
    @NSManaged public var siteURL: String?
    @NSManaged public var title: String?
    @NSManaged public var images: [String]?

}

extension Event : Identifiable {

}
