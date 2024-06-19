//
//  FavoriteRouter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

protocol IFavoriteRouter {
	
	/// Переход на экран DetailI.
	/// - Parameter idEvent: id события для отображения.
	func routeToDetailScreen(idEvent: Int)
}

final class FavoriteRouter: IFavoriteRouter {
	
	private let navigationController: UINavigationController
	private let network: INetworkService
	private let storage: IEventsStorageService
	
	init(navigationController: UINavigationController, network: INetworkService, storage: IEventsStorageService) {
		self.navigationController = navigationController
		self.network = network
		self.storage = storage
	}
	
	func routeToDetailScreen(idEvent: Int) {
		navigationController.pushViewController(
			makeDetailViewController(idEvent: idEvent),
			animated: true
		)
	}
}

private extension FavoriteRouter {
	func makeDetailViewController(idEvent: Int) -> UIViewController {
		let dependencies = DetailAssembly.Dependencies(
			navigationController: navigationController,
			network: network,
			storage: storage
		)
		let parameters = DetailAssembly.Parameters(idEvent: idEvent)
		let viewConteroller = DetailAssembly.makeModule(dependencies: dependencies, parameters: parameters)
		
		return viewConteroller
	}
}
