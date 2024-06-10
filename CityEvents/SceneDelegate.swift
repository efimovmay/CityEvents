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
		let navController = UINavigationController()
		let dependencies = EventsAssembly.Dependencies(navigationController: navController, network: network)
		let eventsViewController = EventsAssembly.makeModule(dependencies: dependencies)
		
		window?.rootViewController = eventsViewController
		window?.makeKeyAndVisible()
	}
}

