//
//  EventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import UIKit

final class EventViewCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	static let identifier = String(describing: EventViewCell.self)
	
	lazy var favoriteButton: UIButton = makeLikeButton()
	
	private lazy var eventImageView: UIImageView = makeImageView()
	private lazy var activityIndicator = UIActivityIndicatorView()
	private lazy var titleLabel: UILabel = makeTitleLabel()
	private lazy var dateView: UIView = makeDateView()
	private lazy var dateLabel: UILabel = makeLabel()
	private lazy var placeLabel: UILabel = makeLabel()
	private lazy var priceLabel: UILabel = makeLabel()

	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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
	
	func configure(
		image: String,
		title: String,
		date: String?,
		place: String?,
		price: String,
		isfavorite: Bool
	) {
		activityIndicator.startAnimating()
		eventImageView.load(urlString: image) {
			self.activityIndicator.stopAnimating()
		}
		titleLabel.text = title
		placeLabel.text = place
		priceLabel.text = price
		dateLabel.text = date
		dateView.isHidden = date != nil ? false : true
		favoriteButton.tintColor = isfavorite ? .systemRed : .gray
	}
}

// MARK: - SetupUI

private extension EventViewCell {
	
	func setupLayout() {
		addSubview(priceLabel)
		addSubview(titleLabel)
		addSubview(eventImageView)
		eventImageView.addSubview(favoriteButton)
		eventImageView.addSubview(dateView)
		eventImageView.addSubview(activityIndicator)
		dateView.addSubview(dateLabel)

		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -Sizes.Padding.half),
			
			eventImageView.topAnchor.constraint(equalTo: topAnchor),
			eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			eventImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -Sizes.Padding.half),
			
			favoriteButton.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: Sizes.Padding.normal),
			favoriteButton.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Sizes.Padding.normal),
			favoriteButton.widthAnchor.constraint(equalToConstant: Sizes.smallButton),
			favoriteButton.heightAnchor.constraint(equalToConstant: Sizes.smallButton),
			
			dateView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -Sizes.Padding.normal),
			dateView.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: Sizes.Padding.normal),
			dateView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, constant: Sizes.Padding.double),
			dateView.heightAnchor.constraint(equalToConstant: Sizes.dateViewHeigth),
			
			dateLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: eventImageView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor),
			
		])
	}
	
	func makeImageView() -> UIImageView {
		let image = UIImageView()
		image.layer.cornerRadius = Sizes.cornerRadius
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		image.isUserInteractionEnabled = true
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = .zero
		label.textAlignment = .left
		label.font = UIFont.boldSystemFont(ofSize: Sizes.Font.titleEvent)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: Sizes.Font.regular)
		label.numberOfLines = .zero
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeDateView() -> UIView{
		let view = UIView()
		view.backgroundColor = Theme.imageSticker
		view.layer.cornerRadius = Sizes.dateViewHeigth / 2
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	
	func makeLikeButton() -> UIButton {
		let button = UIButton(type: .system)
		button.setImage(Theme.ImageIcon.heartFill, for: .normal)
		button.backgroundColor = Theme.imageSticker
		button.layer.cornerRadius = Sizes.smallButton / 2
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
