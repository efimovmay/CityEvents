//
//  EventsSectionHeaderView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import UIKit

final class EventsSectionHeaderView: UICollectionReusableView {
	
	// MARK: - Public properties
	
	static let identifier = String(describing: EventsSectionHeaderView.self)
	
	// MARK: - Private properties
	
	private lazy var titleLabel: UILabel = makeTitleLabel()
	
	// MARK: - Initialization
	
	override init (frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init? (coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func configure(text: String) {
		titleLabel.text = text
	}
}

private extension EventsSectionHeaderView {
	func setupLayout() {
		addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Sizes.Padding.normal),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
