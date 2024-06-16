//
//  Theme.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

enum Theme {
	
	static let mainColor = Colors.white
	static let imageSticker = Colors.darkGray
	static let tintElement = Colors.black
	
	enum ImageIcon {
		static let heart = UIImage(systemName: "heart")
		static let heartFill = UIImage(systemName: "heart.fill")
		static let calendar = UIImage(systemName: "calendar")
		static let location = UIImage(systemName: "location.fill")
		static let comment = UIImage(systemName: "bubble")
		static let search = UIImage(systemName: "magnifyingglass")
		static let price = UIImage(systemName: "rublesign")
		static let chevronDown = UIImage(systemName: "chevron.down")
		static let chevronForvard = UIImage(systemName: "chevron.forward")
	}
}
