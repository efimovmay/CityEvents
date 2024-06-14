//
//  EventsRouter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 10.06.2024.
//

import UIKit

protocol IEventsRouter {
	
	/// Переход на экран DetailInfo.
	func routeToDetailScreen(idEvent: Int)
}

final class EventsRouter: IEventsRouter {
	
	// MARK: - Dependencies
	
	private let navigationController: UINavigationController
	
	// MARK: - Initialization
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public methods
	
	func routeToDetailScreen(idEvent: Int) {
		navigationController.pushViewController(
			getDetailInfoViewController(idEvent: idEvent),
			animated: true
		)
	}
	
	func routeToCalendarScreen() -> Void {
		let presenter = CalendarPresenter()
		let viewController = CalendarViewController(presenter: presenter)
		if let sheet = viewController.sheetPresentationController {
			sheet.detents = [.custom(resolver: { context in
				return 500
			})]
		}
		navigationController.present(viewController, animated: true, completion: nil)
	}
	
	func routeToLocationScreen(compleation: AllLocation) -> Void {

	}
}

// MARK: - Private methods

private extension EventsRouter {
	func getDetailInfoViewController(idEvent: Int) -> UIViewController {
//		let dependencies = DetailInfoAssembly.Dependencies(navigationController: navigationController)
//		let parameters = DetailInfoAssembly.Parameters(character: character)
//		let viewConteroller = DetailInfoAssembly.makeModule(dependencies: dependencies, parameters: parameters)
//		
		return UIViewController()
	}
}
