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
	
	/// Показать alert controller.
	/// - Parameter error: текст ошибки.
	func showAlert(with error: String)
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

