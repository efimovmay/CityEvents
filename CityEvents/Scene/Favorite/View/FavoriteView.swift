//
//  FavoriteView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

final class FavoriteView: UIView {
	// MARK: - Properties
	
	lazy var favoriteTableView: UITableView = makeFavoriteTableView()
	lazy var emptyTableLabel : UILabel = makeLabel()
	
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

private extension FavoriteView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {
		addSubview(favoriteTableView)
		addSubview(emptyTableLabel)
		
		NSLayoutConstraint.activate([
			favoriteTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			favoriteTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			favoriteTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			favoriteTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
			
			emptyTableLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			emptyTableLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			emptyTableLabel.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: Sizes.Padding.double),
			emptyTableLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Sizes.Padding.double),
		])
	}
									
	
	func makeFavoriteTableView() -> UITableView {
		let table = UITableView()
		table.rowHeight = Sizes.FavoriteScreen.rowHeigth
		table.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.text = L10n.FavoriteScreen.noEvents
		label.font = UIFont.systemFont(ofSize: Sizes.Font.titleEvent)
		label.numberOfLines = .zero
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
