//
//  EventViewCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

final class EventViewCell: UICollectionViewCell {
	static let identifier = String(describing: EventViewCell.self)
	
	private lazy var contentStack: UIStackView = makeContentStack()
	private lazy var eventImageView: UIImageView = makeImageView()
	private lazy var titleLabel: UILabel  = makeTitleLabel()
	
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
		titleLabel.text = name
	}
}

// MARK: - SetupUI

private extension EventViewCell {
	func setupUI() {
		backgroundColor = .green
	}
	
	func setupLayout() {
		addSubview(contentStack)
		
		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo: topAnchor),
			contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	func makeImageView() -> UIImageView {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}
	func makeContentStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [eventImageView, titleLabel])
		stack.axis = .vertical
		stack.distribution = .fill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
