//
//  UIColor+Dynamic.swift
//  CityEvents
//

import UIKit

extension UIColor {
	static func color(light: UIColor, dark: UIColor) -> UIColor {
		return .init { traitCollection in
			return traitCollection.userInterfaceStyle == .dark ? dark : light
		}
	}
}
