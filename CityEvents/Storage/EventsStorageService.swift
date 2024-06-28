//
//  EventsStorageService.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 17.06.2024.
//

import Foundation
import CoreData

protocol IEventsStorageService {
	func saveEvent(_ eventForSave: EventModel, completion: @escaping (Bool) -> Void)
	func deleteEvent(withId id: Int, completion: @escaping (Bool) -> Void)
	func getEvent(withId id: Int) -> EventData?
	func getAllEvents() -> [EventData]
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
	
	func saveEvent(_ eventForSave: EventModel, completion: @escaping (Bool) -> Void) {
		persistentContainer.performBackgroundTask { backgroundContext in
			let event = EventData(context: backgroundContext)
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
			
			self.saveContext(context: backgroundContext)
			completion(true)
		}
	}
	
	func deleteEvent(withId id: Int, completion: @escaping (Bool) -> Void) {
		persistentContainer.performBackgroundTask { backgroundContext in
			let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "id == %d", id)
			
			do {
				if let event = try backgroundContext.fetch(fetchRequest).first {
					backgroundContext.delete(event)
					self.saveContext(context: backgroundContext)
					completion(true)
				} else {
					completion(false)
				}
			} catch {
				completion(false)
			}
		}
	}
	
	func getEvent(withId id: Int) -> EventData? {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %d", id)
		fetchRequest.fetchLimit = 1
		
		do {
			return try context.fetch(fetchRequest).first
		} catch {
			print("Fetch event by id failed: \(error)")
			return nil
		}
	}

	func getAllEvents() -> [EventData] {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
		
		do {
			return try context.fetch(fetchRequest)
		} catch {
			print("Fetch failed")
			return []
		}
	}
	
	func eventExists(withId id: Int) -> Bool {
		let context = persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
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
	func saveContext(context: NSManagedObjectContext) {
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
