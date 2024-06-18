//
//  DetailRouter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

protocol IDetailRouter {
	
	/// Вернуться на предыдущий экран.
	func backToPreviousScreen()
	
	/// Открыть сайт в браузере.
	/// - Parameter url: адрес сайта.
	func routeToSite(url: URL)
}

final class DetailRouter: IDetailRouter {
	
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func backToPreviousScreen() {
		navigationController.popViewController(animated: true)
	}
	
	func routeToSite(url: URL) {
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
}

