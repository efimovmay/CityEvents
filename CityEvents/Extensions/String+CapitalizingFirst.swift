//
//  String+CapitalizingFirst.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 10.06.2024.
//

import Foundation

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}
