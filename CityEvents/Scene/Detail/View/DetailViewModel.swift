//
//  DetailViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

struct DetailViewModel {
	let images: [String]
	var isFavorite: Bool
	let title: String
	let date: [String]
	let namePlace: String?
	let address: String?
	let description: String?
	let urlEvent: String
}
