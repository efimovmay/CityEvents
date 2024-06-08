//
//  EventsView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

final class EventsView: UIView {
	// MARK: - Properties
	
	lazy var eventsCollectionView: UICollectionView = makeEventsCollectionView()
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - SetupUI

private extension EventsView {
	func setupUI() {
		backgroundColor = .cyan
	}
	
	func setupLayout() {
		addSubview(eventsCollectionView)
		
		NSLayoutConstraint.activate([
			eventsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			eventsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			eventsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			eventsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func makeEventsCollectionView() -> UICollectionView {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
		collection.register(EventViewCell.self, forCellWithReuseIdentifier: EventViewCell.identifier)
		collection.backgroundColor = .clear
		collection.translatesAutoresizingMaskIntoConstraints = false
		return collection
	}
	
	func createCollectionLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			let itemWidth = layoutEnvironment.traitCollection.verticalSizeClass == .compact ? 0.25 : 0.5
			let sizeItem = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(itemWidth),
				heightDimension: .fractionalHeight(1.0)
			)
			let item = NSCollectionLayoutItem(layoutSize: sizeItem)
			
			let groupHeigth = layoutEnvironment.traitCollection.verticalSizeClass == .compact ? 0.35 : 0.7
			let groupeSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalWidth(groupHeigth)
			)
			let itemCount = layoutEnvironment.traitCollection.verticalSizeClass == .compact ? 4 : 2
			let groupe = NSCollectionLayoutGroup.horizontal(
				layoutSize: groupeSize,
				repeatingSubitem: item,
				count: itemCount
			)
			groupe.interItemSpacing = .fixed(Sizes.Padding.normal)
			
			let headerSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .absolute(Sizes.header)
			)
			let header = NSCollectionLayoutBoundarySupplementaryItem(
				layoutSize: headerSize,
				elementKind: UICollectionView.elementKindSectionHeader,
				alignment: .top)
			
			let section = NSCollectionLayoutSection(group: groupe)
			section.boundarySupplementaryItems = [header]
			section.interGroupSpacing = Sizes.Padding.normal
			section.contentInsets = NSDirectionalEdgeInsets(
				top: .zero,
				leading: Sizes.Padding.normal,
				bottom: .zero,
				trailing: Sizes.Padding.normal
			)
			return section
		}
		return layout
	}
}
