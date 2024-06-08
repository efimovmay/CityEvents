//
//  EventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

final class EventViewCell: UICollectionViewCell {
	static let identifier = String(describing: EventViewCell.self)
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = .zero
		label.textAlignment = .center
		label.text = "text"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
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

private extension EventViewCell {
	func setupUI() {

	}
	
	func setupLayout() {
		addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
}
