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
	func getEvent(withId id: Int, completion: @escaping (EventData?) -> Void)
	func getAllEvents(completion: @escaping ([EventData]) -> Void)
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
	
	func getEvent(withId id: Int, completion: @escaping (EventData?) -> Void) {
		persistentContainer.performBackgroundTask { backgroundContext in
			let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "id == %d", id)
			fetchRequest.fetchLimit = 1
			
			do {
				let event = try backgroundContext.fetch(fetchRequest).first
				completion(event)
			} catch {
				completion(nil)
			}
		}
	}

	func getAllEvents(completion: @escaping ([EventData]) -> Void) {
		persistentContainer.performBackgroundTask { backgroundContext in
			let fetchRequest: NSFetchRequest<EventData> = EventData.fetchRequest()
			
			do {
				let events = try backgroundContext.fetch(fetchRequest)
				completion(events)
			} catch {
				completion([])
			}
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
