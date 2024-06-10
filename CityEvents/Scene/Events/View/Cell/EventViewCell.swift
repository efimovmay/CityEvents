//
//  EventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

final class EventViewCell: UICollectionViewCell {
	static let identifier = String(describing: EventViewCell.self)
	
	private lazy var eventImageView: UIImageView = makeImageView()
	private lazy var nameLabel: UILabel  = makeTitleLabel()
	
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
	
	func configure(image: String, name: String) {
		eventImageView.load(urlString: image) {
			
		}
		nameLabel.text = name
	}
}

// MARK: - SetupUI

private extension EventViewCell {
	func setupUI() {
		backgroundColor = .green
	}
	
	func setupLayout() {
		addSubview(eventImageView)
		eventImageView.addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			eventImageView.topAnchor.constraint(equalTo: topAnchor),
			eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			nameLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: Sizes.Padding.normal),
			nameLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Sizes.Padding.normal),
			nameLabel.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -Sizes.Padding.normal),
		])
	}
	func makeImageView() -> UIImageView {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
