//
//  UserDefaults+enum.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

extension UserDefaults {
	func set<T: RawRepresentable>(_ value: T?, forKey key: String) where T.RawValue == String {
		self.set(value?.rawValue, forKey: key)
	}
	
	func enumValue<T: RawRepresentable>(forKey key: String) -> T? where T.RawValue == String {
		guard let rawValue = self.string(forKey: key) else { return nil }
		return T(rawValue: rawValue)
	}
}
