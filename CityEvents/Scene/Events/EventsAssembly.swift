//
//  EventsAssembly.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 10.06.2024.
//

import UIKit

enum EventsAssembly {
	
	struct Dependencies {
		let navigationController: UINavigationController
		let network: INetworkService
		let storage: IEventsStorageService
		let imageService: IImageLoadService
	}
	
	static func makeModule(dependencies: Dependencies) -> UIViewController {
		let router = EventsRouter(
			navigationController: dependencies.navigationController,
			network: dependencies.network, 
			storage: dependencies.storage, 
			imageService: dependencies.imageService
		)
		let presenter = EventsPresenter(
			router: router,
			network: dependencies.network,
			storage: dependencies.storage,
			imageService: dependencies.imageService
		)
		let viewController = EventsViewController(presenter: presenter)
		
		return viewController
	}
}
