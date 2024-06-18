//
//  SceneDelegate.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		
		let network = NetworkService()
		let storage = EventsStorageService()
		
		let navigationController = UINavigationController()
		navigationController.pushViewController(
			assemblyRootController(navigationController: navigationController, network: network, storage: storage),
			animated: false
		)

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
	
	func assemblyRootController(
		navigationController: UINavigationController,
		network: INetworkService,
		storage: IEventsStorageService
	) -> UIViewController {
		let dependencies = EventsAssembly.Dependencies(
			navigationController: navigationController,
			network: network, 
			storage: storage
		)
		let viewController = EventsAssembly.makeModule(dependencies: dependencies)
		
		return viewController
	}
}
