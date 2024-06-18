//
//  FavoriteView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

final class FavoriteView: UIView {
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - SetupUI

private extension FavoriteView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {
	}
}
