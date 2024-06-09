//
//  RegularEventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import UIKit

final class RegularEventViewCell: UICollectionViewCell {
	static let identifier = String(describing: RegularEventViewCell.self)
	
	private lazy var nameLabel: UILabel = makeTitleLabel()
	
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
	
	func configure(name: String) {
		nameLabel.text = name
	}
}

// MARK: - SetupUI

private extension RegularEventViewCell {
	func setupUI() {
		backgroundColor = .blue
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
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
