//
//  CategoriesEvent.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 12.06.2024.
//

import Foundation

struct CategoriesEvent: Decodable {
	let id: Int
	let slug: String
	let name: String
}
