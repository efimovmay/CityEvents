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
}

final class DetailRouter: IDetailRouter {
	
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func backToPreviousScreen() {
		navigationController.popViewController(animated: true)
	}
}

