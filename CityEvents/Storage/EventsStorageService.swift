//
//  EventsStorageService.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 17.06.2024.
//

import Foundation
import CoreData

protocol IEventsStorageService {
	func saveEvent(_ eventForSave: EventModel)
	func deleteEvent(withId id: Int)
	func getAllEvents() -> [Event]
	func eventExists(withId id: Int) -> Bool
}

final class EventsStorageService: IEventsStorageService {

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CityEvents")
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	func saveEvent(_ eventForSave: EventModel) {
		let context = persistentContainer.viewContext
		let event = Event(context: context)
		event.id = Int64(eventForSave.id)
		event.address = eventForSave.address
		event.dates = eventForSave.dates
		event.place = eventForSave.place
		event.price = eventForSave.price
		event.body = eventForSave.description
		event.siteURL = eventForSave.siteUrl
		event.title = eventForSave.title
		event.images = eventForSave.images
		event.lastDate = eventForSave.lastDate
		event.shortTitle = eventForSave.shortTitle
		saveContext()
	}
	
	func deleteEvent(withId id: Int) {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %d", id)
		
		do {
			let events = try context.fetch(fetchRequest)
			if let event = events.first {
				context.delete(event)
				saveContext()
			} else {
				print("Event with id \(id) not found.")
			}
		} catch {
			print("Error deleting event with id \(id): \(error)")
		}
	}
	
	func getAllEvents() -> [Event] {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
		
		do {
			return try context.fetch(fetchRequest)
		} catch {
			print("Fetch failed")
			return []
		}
	}
	
	func eventExists(withId id: Int) -> Bool {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %d", id)
		fetchRequest.fetchLimit = 1
		
		do {
			let count = try context.count(for: fetchRequest)
			return count > 0
		} catch {
			print("Error checking if event exists: \(error)")
			return false
		}
	}
}

private extension EventsStorageService {
	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
