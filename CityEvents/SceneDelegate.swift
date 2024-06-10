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
		let presenter = EventsPresenter(network: network)
		let viewController = EventsViewController(presenter: presenter)
		let navController = UINavigationController(rootViewController: viewController)
		
		window?.rootViewController = navController
		window?.makeKeyAndVisible()
	}
}
