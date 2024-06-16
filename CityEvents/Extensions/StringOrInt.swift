//
//  StringOrInt.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 16.06.2024.
//

import Foundation

enum StringOrInt: Codable {
	case string(String)
	case int(Int)
	
	func getValue() -> String {
		switch self {
		case .string(let string):
			return string
		case .int(let int):
			return "\(int)"
		}
	}
	
	init(from decoder: Decoder) throws {
		if let value = try? decoder.singleValueContainer().decode(String.self) {
			self = .string(value)
			return
		}
		if let value = try? decoder.singleValueContainer().decode(Int.self) {
			self = .int(value)
			return
		}
		throw Error.decodingError
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		switch self {
		case .string(let value):
			try container.encode(value)
		case .int(let value):
			try container.encode(value)
		}
	}
	
	enum Error: Swift.Error {
		case decodingError
	}
}
