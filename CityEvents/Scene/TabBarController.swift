//
//  TabBarController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

class TabBarController: UITabBarController {
	// MARK: - Dependencies
	
	private var network = NetworkService()
	private var storage = EventsStorageService()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		setupTabs()
	}
}
// MARK: - Private methods

extension TabBarController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if let navController = viewController as? UINavigationController {
			navController.popToRootViewController(animated: false)
		}
	}
}

// MARK: - Private methods

private extension TabBarController {
	func setupTabs() {
		
		let eventsController = assemblyEventsController()
		eventsController.tabBarItem.title = L10n.TabBar.events
		eventsController.tabBarItem.image = Theme.ImageIcon.events
		
		let favoriteController = assemblyFavoriteController()
		favoriteController.tabBarItem.title = L10n.TabBar.favorite
		favoriteController.tabBarItem.image = Theme.ImageIcon.heartFill
		
		self.setViewControllers([eventsController, favoriteController], animated: true)
	}
	
	func assemblyEventsController() -> UINavigationController {
		let navigationController = UINavigationController()
		let dependencies = EventsAssembly.Dependencies(
			navigationController: navigationController,
			network: network,
			storage: storage
		)
		let viewController = EventsAssembly.makeModule(dependencies: dependencies)
		navigationController.pushViewController(viewController, animated: false)
		
		return navigationController
	}
	
	func assemblyFavoriteController() -> UINavigationController {
		let navigationController = UINavigationController()
		let dependencies = FavoriteAssembly.Dependencies(
			navigationController: navigationController,
			network: network,
			storage: storage
		)
		let viewController = FavoriteAssembly.makeModule(dependencies: dependencies)
		navigationController.pushViewController(viewController, animated: false)
		
		return navigationController
	}
}
