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
	}
	
	static func makeModule(dependencies: Dependencies) -> UIViewController {
		let router = EventsRouter(navigationController: dependencies.navigationController)
		let presenter = EventsPresenter(router: router, network: dependencies.network)
		let viewController = EventsViewController(presenter: presenter)
		
		return viewController
	}
}
