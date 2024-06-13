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
		setupUI()
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
		backgroundColor = Colors.white
	}
	
	func setupLayout() {
		addSubview(eventsCollectionView)
		
		NSLayoutConstraint.activate([
			eventsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Sizes.Padding.half),
			eventsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			eventsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			eventsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func makeEventsCollectionView() -> UICollectionView {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
		collection.register(
			CategoryCell.self,
			forCellWithReuseIdentifier: CategoryCell.identifier
		)
		collection.register(
			EventViewCell.self,
			forCellWithReuseIdentifier: EventViewCell.identifier
		)
		collection.register(
			EventsSectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: EventsSectionHeaderView.identifier
		)
		collection.backgroundColor = .clear
		collection.translatesAutoresizingMaskIntoConstraints = false
		
		return collection
	}
	
	private func createCollectionLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
			guard let section = EventsViewModel.Sections(rawValue: sectionIndex) else { return nil }
			switch section {
			case .category:
				return self.createCategorySection()
			case .events:
				return self.createEventsSection()
			}
		}
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = Sizes.Padding.normal
		layout.configuration = config
		
		return layout
	}
	
	private func createCategorySection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .estimated(Sizes.categoryWidthMinimum),
			heightDimension: .absolute(Sizes.categoryHeigth)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension:  .estimated(Sizes.categoryWidthMinimum),
			heightDimension: .absolute(Sizes.categoryHeigth)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		section.interGroupSpacing = Sizes.Padding.half
		section.contentInsets = NSDirectionalEdgeInsets(
			top: .zero,
			leading: Sizes.Padding.normal,
			bottom: .zero,
			trailing: Sizes.Padding.normal
		)
		return section
	}
	
	private func createEventsSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(0.5)
		)
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = Sizes.Padding.semiDouble
		section.contentInsets = NSDirectionalEdgeInsets(
			top: .zero,
			leading: Sizes.Padding.normal,
			bottom: .zero,
			trailing: Sizes.Padding.normal
		)
		return section
	}
}
