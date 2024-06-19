//
//  LocationView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

final class LocationView: UIView {
	// MARK: - Properties
	
	static let cellIdentifier = "locationCell"
	lazy var locationTableView: UITableView = makeLocationTableView()
	
	private lazy var titleLabel: UILabel = makeTitleLabel()
	
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
}

// MARK: - SetupUI

private extension LocationView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {
		addSubview(titleLabel)
		addSubview(locationTableView)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Padding.normal),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
			
			locationTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Sizes.Padding.normal),
			locationTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			locationTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			locationTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.Padding.normal),
		])
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.text = L10n.LocationScreen.title
		label.font = UIFont.boldSystemFont(ofSize: Sizes.Font.title)
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeLocationTableView() -> UITableView {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: LocationView.cellIdentifier)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}
}
