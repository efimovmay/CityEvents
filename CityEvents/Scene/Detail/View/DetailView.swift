//
//  DetailView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

final class DetailView: UIView {
	
	// MARK: - Properties
	
	lazy var imagesCollectionView: UICollectionView = makeImagesCollectionView()
	lazy var contentStack: UIStackView = makeContentStack()
	
	lazy var titleLabel: UILabel = makeTitleLabel()
	
	lazy var dateStack: UIStackView = makeHorizontalStack(subview: [dateImageView, dateLabel])
	lazy var dateImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.calendar)
	lazy var dateLabel: UILabel = makeLabel()
	
	lazy var priceStack: UIStackView = makeHorizontalStack(subview: [priceImageView, priceLabel])
	lazy var priceImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.price)
	lazy var priceLabel: UILabel = makeLabel()
	
	lazy var addressStack: UIStackView = makeHorizontalStack(subview: [addressImageView, addressLabel])
	lazy var addressImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.location)
	lazy var addressLabel: UILabel = makeLabel()
	
	lazy var descriptionTitleLabel: UILabel = makeLabel()
	lazy var descriptionLabel: UILabel = makeLabel()
	
	lazy var onSiteButton: UIButton = makeButton()

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
	
	func configure(
		title: String,
		dates: String,
		price: String,
		address: String?,
		description: String?,
		siteUrl: String
	) {
		titleLabel.text = title
		dateLabel.text = dates
		priceLabel.text = price
		addressLabel.text = address
		descriptionTitleLabel.text = "Описание"
		descriptionLabel.text = description
		
	}
}

// MARK: - SetupUI

private extension DetailView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {
		addSubview(contentStack)
		
		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo:  safeAreaLayoutGuide.topAnchor),
			contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
			contentStack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -Sizes.Padding.normal),
			
			onSiteButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5),
			onSiteButton.heightAnchor.constraint(equalToConstant: Sizes.CalendarScreen.doneButtonHeith),
		])
	}
	
	func makeImagesCollectionView() -> UICollectionView {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
		collection.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
		collection.backgroundColor = .clear
		collection.translatesAutoresizingMaskIntoConstraints = false
		return collection
	}
	
	func createCollectionLayout() -> UICollectionViewCompositionalLayout {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(0.3)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .paging
		
		return UICollectionViewCompositionalLayout(section: section)
	}
	
	func makeContentStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [
			titleLabel,
			dateStack,
			priceStack,
			addressStack,
			descriptionTitleLabel,
			descriptionLabel,
			onSiteButton
		])
		stack.spacing = Sizes.Padding.normal
		stack.distribution = .equalCentering
		stack.axis = .vertical
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeHorizontalStack(subview: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subview)
		stack.spacing = Sizes.Padding.double
		stack.axis = .horizontal
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
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
		label.numberOfLines = .zero
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: Sizes.Font.regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeIconImageView(image: UIImage?) -> UIImageView {
		let imageView = UIImageView()
		if let image = image {
			imageView.image = image
		}
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}
	
	func makeButton() -> UIButton {
		let button = UIButton()
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.baseBackgroundColor = .systemBlue
		config.attributedTitle = AttributedString("Перейти на сайт", attributes: AttributeContainer([
			NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: Sizes.Font.regular)
		]))
		button.configuration = config
		
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
