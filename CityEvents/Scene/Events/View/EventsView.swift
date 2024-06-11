//
//  EventsView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 08.06.2024.
//

import UIKit

final class EventsView: UIView {
	// MARK: - Properties
	
	enum Sections: Int, CaseIterable {
		case recomendation, regular
	}
	
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
			eventsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			eventsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			eventsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			eventsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func makeEventsCollectionView() -> UICollectionView {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
		collection.register(
			EventViewCell.self,
			forCellWithReuseIdentifier: EventViewCell.identifier
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
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
			guard let section = Sections(rawValue: sectionIndex) else { return nil }
			switch section {
			case .recomendation:
				return self.createRecomandationSection()
			case .regular:
				return self.createVerticalSection()
			}
		}
		
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 50
		layout.configuration = config
		
		return layout
	}
	
	private func createRecomandationSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalWidth(0.6)
		)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let headerSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(60)
		)
		let header = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top)
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [header]
		section.orthogonalScrollingBehavior = .paging
		
		return section
	}
	
	private func createVerticalSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(0.9)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(0.5)
		)
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let itemSpacing = CGFloat(10)
		group.interItemSpacing = .fixed(itemSpacing)
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(
			top: .zero,
			leading: Sizes.Padding.normal,
			bottom: .zero,
			trailing: Sizes.Padding.normal
		)
		
		return section
	}
}
