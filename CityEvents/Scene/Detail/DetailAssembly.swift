//
//  DetailAssembly.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

enum DetailAssembly {
	struct Parameters {
		let idEvent: Int
	}
	
	struct Dependencies {
		let navigationController: UINavigationController
		let network: INetworkService
		let storage: IEventsStorageService
		let imageService: IImageLoadService
	}
	
	static func makeModule(dependencies: Dependencies, parameters: Parameters) -> UIViewController {
		let router = DetailRouter(navigationController: dependencies.navigationController)
		let presenter = DetailPresenter(
			router: router,
			network: dependencies.network, 
			storage: dependencies.storage, 
			imageService: dependencies.imageService,
			idEvent: parameters.idEvent
		)
		let viewController = DetailViewController(presenter: presenter)
		
		return viewController
	}
}
