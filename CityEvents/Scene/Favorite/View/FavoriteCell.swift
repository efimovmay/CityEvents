//
//  FavoriteCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit
 
final class FavoriteCell: UITableViewCell {
	// MARK: - Properties
	
	static let identifier = String(describing: FavoriteCell.self)
	
	lazy var eventImageView: UIImageView = makeImageView()
	lazy var nameEventLabel: UILabel = makeLabel()
	lazy var lastDateLabel: UILabel = makeLabel()
	lazy var activityIndicator = UIActivityIndicatorView()
	
	// MARK: - Initialization
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		eventImageView.image = nil
	}
	
	// MARK: - Public methods
	
	func configure(nameEvent: String, lastDate: String) {
		nameEventLabel.text = nameEvent	
		lastDateLabel.text = lastDate
	}
}

// MARK: - SetupUI

private extension FavoriteCell {
	func setupUI() {
		nameEventLabel.font = UIFont.boldSystemFont(ofSize: Sizes.Font.regular)
		lastDateLabel.font = UIFont.systemFont(ofSize: Sizes.Font.regular)
	}
	
	func setupLayout() {
		addSubview(eventImageView)
		addSubview(nameEventLabel)
		addSubview(lastDateLabel)
		
		let constraints = [
			eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.Padding.half),
			eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.Padding.normal),
			eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.Padding.half),
			eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor, multiplier: 1.3),
			
			nameEventLabel.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Padding.half),
			nameEventLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: Sizes.Padding.normal),
			nameEventLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
			
			lastDateLabel.topAnchor.constraint(equalTo: nameEventLabel.bottomAnchor, constant: Sizes.Padding.half),
			lastDateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: Sizes.Padding.normal),
			lastDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
			lastDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Sizes.Padding.half),
		]
		for constraint in constraints {
			constraint.priority = UILayoutPriority(999)
		}
		NSLayoutConstraint.activate(constraints)
	}
	
	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = Sizes.cornerRadius
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.numberOfLines = .zero
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
