//
//  FavoriteAssembly.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

enum FavoriteAssembly {
	
	struct Dependencies {
		let navigationController: UINavigationController
		let network: INetworkService
		let storage: IEventsStorageService
	}
	
	static func makeModule(dependencies: Dependencies) -> UIViewController {
		let router = FavoriteRouter(
			navigationController: dependencies.navigationController,
			network: dependencies.network,
			storage: dependencies.storage
		)
		let presenter = FavoritePresenter(
			router: router,
			storage: dependencies.storage
		)
		let viewController = FavoriteViewController(presenter: presenter)
		
		return viewController
	}
}