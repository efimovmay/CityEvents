//
//  DetailViewModel.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

struct DetailViewModel {
	
	var isFavorite: Bool
	let title: String
	let dates: String
	let price: String
	let address: String?
	let description: String?
	let siteUrl: String
}
