//
//  RegularEventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import UIKit

final class RegularEventViewCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	static let identifier = String(describing: EventViewCell.self)
	lazy var favoriteButton: UIButton = makeLikeButton()
	
	private lazy var contentStack: UIStackView = makeContentStack()
	private lazy var eventImageView: UIImageView = makeImageView()
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
	
	func configure(image: String, title: String, date: String?, place: String?, price: String) {
		eventImageView.load(urlString: image) {
			
		}
		titleLabel.text = title
		placeLabel.text = place
		priceLabel.text = price
		dateLabel.text = date
		dateView.isHidden = date != nil ? false : true
	}
}

// MARK: - SetupUI

private extension RegularEventViewCell {
	
	func setupLayout() {
		addSubview(contentStack)
		eventImageView.addSubview(favoriteButton)
		eventImageView.addSubview(dateView)
		dateView.addSubview(dateLabel)
		
		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo: topAnchor),
			contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			favoriteButton.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: Sizes.Padding.normal),
			favoriteButton.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -Sizes.Padding.normal),
			favoriteButton.widthAnchor.constraint(equalToConstant: Sizes.likeButton),
			favoriteButton.heightAnchor.constraint(equalToConstant: Sizes.likeButton),
			
			dateView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -Sizes.Padding.normal),
			dateView.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: Sizes.Padding.normal),
			dateView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, constant: Sizes.Padding.double),
			dateView.heightAnchor.constraint(equalToConstant: 34),
			
			dateLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor)
		])
	}
	
	func makeContentStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [eventImageView, titleLabel, priceLabel])
		stack.axis = .vertical
		stack.spacing = Sizes.Padding.half
		stack.distribution = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeImageView() -> UIImageView {
		let image = UIImageView()
		image.layer.cornerRadius = Sizes.cornerRadius
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
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
		label.numberOfLines = .zero
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeDateView() -> UIView{
		let view = UIView()
		view.backgroundColor = Theme.imageSticker
		view.layer.cornerRadius = 17
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	
	func makeLikeButton() -> UIButton {
		let button = UIButton(type: .custom)
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .default)
		button.setImage(Theme.ImageIcon.heartFill?.withConfiguration(imageConfig), for: .normal)
		button.tintColor = .systemRed
		button.backgroundColor = Theme.imageSticker
		button.contentMode = .center
		button.imageView?.contentMode = .scaleAspectFit
		button.layer.cornerRadius = Sizes.likeButton / 2
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
