//
//  EventsRouter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 10.06.2024.
//

import UIKit

protocol IEventsRouter {
	/// Переход на экран DetailI.
	/// - Parameter idEvent: id события для отображения.
	func routeToDetailScreen(idEvent: Int)
	
	/// Переход на экран Calendar.
	/// - Parameter setDateClosure: замыкание для обновления даты.
	func routeToCalendarScreen(setDateClosure: SetDateClosure?) -> Void
	
	/// Переход на экран Location.
	/// - Parameter setLocationClosure: замыкание для обновления локации.
	func routeToLocationScreen(setLocationClosure: SetLocationClosure?) -> Void
	
	/// Закрвть модальный экран.
	func dismissModalScreen()
	
	/// Показать alert controller.
	/// - Parameter error: текст ошибки.
	func showAlert(with error: String)
}

final class EventsRouter: IEventsRouter {

	private let navigationController: UINavigationController
	private let network: INetworkService
	private let storage: IEventsStorageService
	private let imageService: IImageLoadService

	init(
		navigationController: UINavigationController,
		network: INetworkService,
		storage: IEventsStorageService,
		imageService: IImageLoadService
	) {
		self.navigationController = navigationController
		self.network = network
		self.storage = storage
		self.imageService = imageService
	}

	func routeToDetailScreen(idEvent: Int) {
		navigationController.pushViewController(
			makeDetailViewController(idEvent: idEvent),
			animated: true
		)
	}
	
	func routeToCalendarScreen(setDateClosure: SetDateClosure?) -> Void {
		navigationController.present(
			makeCalendarViewController(setDateClosure: setDateClosure),
			animated: true
		)
	}
	
	func routeToLocationScreen(setLocationClosure: SetLocationClosure?) -> Void {
		navigationController.present(
			makeLocationViewController(setLocationClosure: setLocationClosure),
			animated: true
		)
	}
	
	func dismissModalScreen() {
		navigationController.dismiss(animated: true)
	}
	
	func showAlert(with error: String) {
		let alert = UIAlertController(
			title: L10n.Common.error.capitalized,
			message: error,
			preferredStyle: UIAlertController.Style.alert
		)
		alert.addAction(UIAlertAction(
			title: L10n.Common.ok,
			style: UIAlertAction.Style.default, handler: nil
		))
		navigationController.present(alert, animated: true, completion: nil)
	}
}

private extension EventsRouter {
	func makeDetailViewController(idEvent: Int) -> UIViewController {
		let dependencies = DetailAssembly.Dependencies(
			navigationController: navigationController,
			network: network, 
			storage: storage, 
			imageService: imageService
		)
		let parameters = DetailAssembly.Parameters(idEvent: idEvent)
		let viewConteroller = DetailAssembly.makeModule(dependencies: dependencies, parameters: parameters)
		
		return viewConteroller
	}
	
	func makeCalendarViewController(setDateClosure: SetDateClosure?) -> UIViewController {
		let presenter = CalendarPresenter(router: self, setDateClosure: setDateClosure)
		let viewController = CalendarViewController(presenter: presenter)
		if let sheet = viewController.sheetPresentationController {
			sheet.detents = [.custom(resolver: { context in
				return Sizes.CalendarScreen.screenHeigth
			})]
		}
		
		return viewController
	}
	
	func makeLocationViewController(setLocationClosure: SetLocationClosure?) -> UIViewController {
		let presenter = LocationPresenter(router: self, setLocationClosure: setLocationClosure)
		let viewController = LocationViewController(presenter: presenter)
		
		return viewController
	}
}
