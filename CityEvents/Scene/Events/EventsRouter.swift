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
	
	/// Закрвть модальный экран.
	func dismissModalScreen()
}

final class EventsRouter: IEventsRouter {

	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func routeToDetailScreen(idEvent: Int) {
		navigationController.pushViewController(
			getDetailInfoViewController(idEvent: idEvent),
			animated: true
		)
	}
	
	func routeToCalendarScreen(setDateClosure: SetDateClosure?) -> Void {
		let presenter = CalendarPresenter(router: self, setDateClosure: setDateClosure)
		let viewController = CalendarViewController(presenter: presenter)
		if let sheet = viewController.sheetPresentationController {
			sheet.detents = [.custom(resolver: { context in
				return Sizes.CalendarScreen.screenHeigth
			})]
		}
		
		navigationController.present(viewController, animated: true, completion: nil)
	}
	
	func routeToLocationScreen(compleation: AllLocation) -> Void {

	}
	
	func dismissModalScreen() {
		navigationController.dismiss(animated: true)
	}
}

private extension EventsRouter {
	func getDetailInfoViewController(idEvent: Int) -> UIViewController {
//		let dependencies = DetailInfoAssembly.Dependencies(navigationController: navigationController)
//		let parameters = DetailInfoAssembly.Parameters(character: character)
//		let viewConteroller = DetailInfoAssembly.makeModule(dependencies: dependencies, parameters: parameters)
//		
		return UIViewController()
	}
}
