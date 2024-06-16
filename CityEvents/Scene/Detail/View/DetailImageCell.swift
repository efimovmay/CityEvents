//
//  DetailImageCell.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 16.06.2024.
//

import UIKit

final class DetailImageCell: UICollectionViewCell {
	// MARK: - Properties
	
	static let identifier = String(describing: DetailImageCell.self)
	lazy var eventImageView: UIImageView = makeImageView()
	
	private lazy var activityIndicator = UIActivityIndicatorView()
	
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
	
	func configure(imageUrl: String) {
		activityIndicator.startAnimating()
		eventImageView.load(urlString: imageUrl) {
			self.activityIndicator.stopAnimating()
		}
	}
}

// MARK: - SetupUI

private extension DetailImageCell {
	
	func setupLayout() {
		addSubview(eventImageView)
		eventImageView.addSubview(activityIndicator)
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			eventImageView.topAnchor.constraint(equalTo: topAnchor),
			eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: eventImageView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor),
		])
	}
	
	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}
}
