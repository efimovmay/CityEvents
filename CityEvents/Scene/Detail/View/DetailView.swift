//
//  DetailView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

final class DetailView: UIView {
	

	
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

private extension DetailView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {

		
		NSLayoutConstraint.activate([

		])
	}
	

}
