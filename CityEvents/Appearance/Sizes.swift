//
//  Sizes.swift
//  CollectionApp
//
//  Created by Aleksey Efimov on 06.05.2024.
//

import Foundation

enum Sizes {
	
	// Common
	static let cornerRadius: CGFloat = 10
	
	// EventsScreen
	static let smallButton: CGFloat = 44
	static let iconSmallButton: CGFloat = 24
	static let dateViewHeigth: CGFloat = 30
	static let categoryHeigth: CGFloat = 40
	static let categoryWidthMinimum: CGFloat = 50
	
	enum CalendarScreen {
		static let screenHeigth: CGFloat = 500
		static let doneButtonHeith: CGFloat = 50
	}
	
	enum DetailScreen {
		static let imagesCollectionHeigth: CGFloat = 270
		static let iconSize: CGFloat = 30
	}

	enum FavoriteScreen {
		static let rowHeigth: CGFloat = 130
	}

	enum Font {
		static let title: CGFloat = 28
		static let detailTitle: CGFloat = 22
		static let regular: CGFloat = 16
		static let titleEvent: CGFloat = 18
	}
	
	enum Padding {
		static let half: CGFloat = 8
		static let normal: CGFloat = 16
		static let semiDouble: CGFloat = 24
		static let double: CGFloat = 32
		static let max: CGFloat = 40
	}
}
