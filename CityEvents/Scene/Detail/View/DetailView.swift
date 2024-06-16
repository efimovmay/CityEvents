//
//  DetailView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

final class DetailView: UIView {
	
	lazy var text: UITextView = {
		let l = UITextView()
		l.translatesAutoresizingMaskIntoConstraints = false
		return l
	}()
	
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
		addSubview(text)
		
		NSLayoutConstraint.activate([
			text.topAnchor.constraint(equalTo: topAnchor),
			text.leadingAnchor.constraint(equalTo: leadingAnchor),
			text.trailingAnchor.constraint(equalTo: trailingAnchor),
			text.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	

}
