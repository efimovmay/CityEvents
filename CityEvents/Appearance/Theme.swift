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
	
	enum ImageIcon {
		static let heart = UIImage(systemName: "heart")
		static let heartFill = UIImage(systemName: "heart.fill")
		static let calendar = UIImage(systemName: "calendar")
		static let location = UIImage(systemName: "mappin.and.ellipse")
		static let comment = UIImage(systemName: "bubble")
		static let search = UIImage(systemName: "magnifyingglass")
		static let filter = UIImage(systemName: "arrow.up.arrow.down")
		static let chevronDown = UIImage(systemName: "chevron.down")
		static let chevronForvard = UIImage(systemName: "chevron.forward")
	}
}
