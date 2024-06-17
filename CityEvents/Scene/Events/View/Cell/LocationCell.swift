//
//  LocationCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import UIKit

final class LocationCell: UICollectionViewCell {
	// MARK: - Properties
	
	static let identifier = String(describing: LocationCell.self)
	
	lazy var setLocationButton: UIButton = makeButton()
	lazy var locationLabel: UILabel = makeLabel()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - SetupUI

private extension LocationCell {
	
	func setupLayout() {
		addSubview(locationLabel)
		addSubview(setLocationButton)
		
		NSLayoutConstraint.activate([
			locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			locationLabel.topAnchor.constraint(equalTo: topAnchor),
			
			setLocationButton.widthAnchor.constraint(equalToConstant: Sizes.smallButton),
			setLocationButton.heightAnchor.constraint(equalToConstant: Sizes.smallButton),
			setLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			setLocationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.Padding.half),
		])
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.numberOfLines = .zero
		label.font = UIFont.boldSystemFont(ofSize: Sizes.Font.title)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeButton() -> UIButton {
		let button = UIButton(type: .system)
		let imageConfig = UIImage.SymbolConfiguration(pointSize: Sizes.iconSmallButton, weight: .regular, scale: .default)
		button.setImage(Theme.ImageIcon.location?.withConfiguration(imageConfig), for: .normal)
		button.tintColor = Colors.black
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
