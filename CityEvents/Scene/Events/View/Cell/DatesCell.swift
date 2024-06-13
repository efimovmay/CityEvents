//
//  DatesCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import UIKit

final class DatesCell: UICollectionViewCell {
	// MARK: - Properties
	
	static let identifier = String(describing: DatesCell.self)
	
	lazy var setDateButton: UIButton = makeButton()
	private lazy var datesLabel: UILabel = makeLabel()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(dates: String) {
		datesLabel.text = dates
	}
}

// MARK: - SetupUI

private extension DatesCell {
	
	func setupLayout() {
		addSubview(setDateButton)
		addSubview(datesLabel)
		
		NSLayoutConstraint.activate([
			setDateButton.heightAnchor.constraint(equalToConstant: Sizes.smallButton),
			setDateButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			setDateButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			datesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			datesLabel.trailingAnchor.constraint(lessThanOrEqualTo: setDateButton.leadingAnchor),
			datesLabel.topAnchor.constraint(equalTo: topAnchor),
		])
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.numberOfLines = .zero
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeButton() -> UIButton {
		let button = UIButton(type: .system)
		
		var config = UIButton.Configuration.filled()
		config.title = L10n.EventsScreen.setDateTitle
		config.baseBackgroundColor = Theme.imageSticker
		config.baseForegroundColor = Theme.tintElement
		config.cornerStyle = .capsule
		config.image = Theme.ImageIcon.calendar
		config.imagePlacement = .leading
		config.imagePadding = Sizes.Padding.half
		config.contentInsets = NSDirectionalEdgeInsets(
			top: .zero,
			leading: Sizes.Padding.normal,
			bottom: .zero,
			trailing: Sizes.Padding.normal
		)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.configuration = config
		
		return button
	}
}
