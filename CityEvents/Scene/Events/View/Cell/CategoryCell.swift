//
//  CategoryCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 12.06.2024.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
	// MARK: - Properties
	
	static let identifier = String(describing: CategoryCell.self)
	
	private lazy var categoryView: UIView = makeCategoryView()
	private lazy var categoryNameLabel: UILabel = makeLabel()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(categoryName: String) {
		categoryNameLabel.text = categoryName
	}
}

// MARK: - SetupUI

private extension CategoryCell {
	
	func setupLayout() {
		categoryView.addSubview(categoryNameLabel)
		addSubview(categoryView)
		
		NSLayoutConstraint.activate([
			categoryView.widthAnchor.constraint(equalTo: categoryNameLabel.widthAnchor, constant: Sizes.Padding.double),
			categoryView.topAnchor.constraint(equalTo: topAnchor),
			categoryView.bottomAnchor.constraint(equalTo: bottomAnchor),
			categoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
			categoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			categoryNameLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
			categoryNameLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor)
		])
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeCategoryView() -> UIView{
		let view = UIView()
		view.backgroundColor = Theme.imageSticker
		view.layer.cornerRadius = Sizes.categoryHeigth / 2
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
}
