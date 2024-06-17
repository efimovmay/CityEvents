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
	lazy var onSiteButton: UIButton = makeButton()
	lazy var favoriteButton: UIButton = makeFavoriteButton()
	lazy var activityIndicator: UIActivityIndicatorView = makeActivityIndicator()
	
	private lazy var scrollView: UIScrollView = makeScrollView()
	
	private lazy var titleStack: UIStackView = makeHorizontalStack(subview: [titleLabel, favoriteButton])
	private lazy var titleLabel: UILabel = makeTitleLabel()
	
	private lazy var dateStack: UIStackView = makeHorizontalStack(subview: [dateImageView, dateLabel])
	private lazy var dateImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.calendar)
	private lazy var dateLabel: UILabel = makeLabel()
	
	private lazy var priceStack: UIStackView = makeHorizontalStack(subview: [priceImageView, priceLabel])
	private lazy var priceImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.price)
	private lazy var priceLabel: UILabel = makeLabel()
	
	private lazy var addressStack: UIStackView = makeHorizontalStack(subview: [addressImageView, addressLabel])
	private lazy var addressImageView: UIImageView = makeIconImageView(image: Theme.ImageIcon.location)
	private lazy var addressLabel: UILabel = makeLabel()
	
	private lazy var descriptionTitleLabel: UILabel = makeTitleLabel()
	private lazy var descriptionLabel: UILabel = makeLabel()
	
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
	
	// MARK: - Public methods
	
	func configure(
		isFavorite: Bool,
		title: String,
		dates: String,
		price: String,
		address: String?,
		description: String?
	) {
		titleLabel.text = title
		dateLabel.text = dates
		priceLabel.text = price
		if address == nil {
			addressStack.isHidden = true
		} else {
			addressStack.isHidden = false
			addressLabel.text = address
		}
		descriptionTitleLabel.text = L10n.DetailScreen.textDescriptionLabel
		descriptionLabel.text = description
		favoriteButton.tintColor = isFavorite ? .systemRed : .gray
	}
}

// MARK: - SetupUI

private extension DetailView {
	func setupUI() {
		backgroundColor = .systemBackground
		titleLabel.font = UIFont.boldSystemFont(ofSize: Sizes.Font.detailTitle)
	}
	
	func setupLayout() {
		addSubview(scrollView)
		addSubview(activityIndicator)
		scrollView.addSubview(imagesCollectionView)
		scrollView.addSubview(contentStack)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo:  safeAreaLayoutGuide.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			
			imagesCollectionView.topAnchor.constraint(equalTo:  scrollView.topAnchor),
			imagesCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			imagesCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			imagesCollectionView.heightAnchor.constraint(equalToConstant: Sizes.DetailScreen.imagesCollectionHeigth),
			
			favoriteButton.widthAnchor.constraint(equalToConstant: Sizes.smallButton),
			favoriteButton.heightAnchor.constraint(equalToConstant: Sizes.smallButton),
			
			contentStack.topAnchor.constraint(equalTo:  imagesCollectionView.bottomAnchor, constant: Sizes.Padding.normal),
			contentStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Sizes.Padding.double),
			
			onSiteButton.heightAnchor.constraint(equalToConstant: Sizes.CalendarScreen.doneButtonHeith),
			
			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
		addViewInStack()
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
			heightDimension: .fractionalHeight(1.0)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .paging
		
		return UICollectionViewCompositionalLayout(section: section)
	}
	
	func makeContentStack() -> UIStackView {
		let stack = UIStackView()
		stack.spacing = Sizes.Padding.normal
		stack.alignment = .fill
		stack.isHidden = true
		stack.distribution = .equalSpacing
		stack.axis = .vertical
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func addViewInStack() {
		contentStack.addArrangedSubview(titleStack)
		contentStack.addArrangedSubview(dateStack)
		contentStack.addArrangedSubview(priceStack)
		contentStack.addArrangedSubview(addressStack)
		contentStack.addArrangedSubview(descriptionTitleLabel)
		contentStack.addArrangedSubview(descriptionLabel)
		contentStack.addArrangedSubview(onSiteButton)
	}
	
	func makeScrollView() -> UIScrollView {
		let scroll = UIScrollView()
		scroll.translatesAutoresizingMaskIntoConstraints = false
		return scroll
	}
	
	func makeHorizontalStack(subview: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subview)
		stack.spacing = Sizes.Padding.normal
		stack.alignment = .leading
		stack.distribution = .fill
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
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeIconImageView(image: UIImage?) -> UIImageView {
		let imageView = UIImageView()
		if let image = image {
			imageView.image = image
		}
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalToConstant: Sizes.DetailScreen.iconSize),
			imageView.heightAnchor.constraint(equalToConstant: Sizes.DetailScreen.iconSize)
		])
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}
	
	func makeButton() -> UIButton {
		let button = UIButton()
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.baseBackgroundColor = .systemBlue
		config.attributedTitle = AttributedString(
			L10n.DetailScreen.onSiteButtonTitle,
			attributes: AttributeContainer([
				NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: Sizes.Font.regular)
			])
		)
		button.configuration = config
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeFavoriteButton() -> UIButton {
		let button = UIButton(type: .system)
		button.setImage(Theme.ImageIcon.heartFill, for: .normal)
		button.backgroundColor = Theme.imageSticker
		button.layer.cornerRadius = Sizes.smallButton / 2
		button.clipsToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeActivityIndicator() -> UIActivityIndicatorView {
		let indicator = UIActivityIndicatorView()
		indicator.style = .large
		indicator.startAnimating()
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}
}
