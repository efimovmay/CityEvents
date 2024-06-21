//
//  String+capitalizedFirst.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 21.06.2024.
//

extension String {
	var capitalizedSentence: String {
		let firstLetter = self.prefix(1).capitalized
		let remainingLetters = self.dropFirst().lowercased()
		return firstLetter + remainingLetters
	}
}
