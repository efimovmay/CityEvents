//
//  DetailViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

protocol IDetailView: AnyObject {
	func render(viewModel: DetailViewModel)
	func reloadImagesCollection()
	func changeFavoriteIcon(isFavorite: Bool)
}

final class DetailViewController: UIViewController {

	private let presenter: IDetailPresenter
	private lazy var contentView = DetailView()
	
	// MARK: - Initialization
	
	init(presenter: IDetailPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - Initialization
	
	override func loadView() {
		view = contentView
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter.viewIsReady(view: self)
	}
}

// MARK: - Actions

private extension DetailViewController {
	@objc
	func onSiteButtonPressed() {
		presenter.openSite()
	}
	
	@objc
	func favoriteButtonPressed() {
		presenter.favoriteButtonPressed()
	}
}

// MARK: - SetupUI

private extension DetailViewController {
	func setupUI() {
		contentView.imagesCollectionView.dataSource = self
		contentView.imagesCollectionView.delegate = self
		contentView.onSiteButton.addTarget(self, action: #selector(onSiteButtonPressed), for: .touchUpInside)
		contentView.favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
	}
}

// MARK: - SetupUI

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter.images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: DetailImageCell.identifier,
			for: indexPath
		) as? DetailImageCell else { return UICollectionViewCell() }
		
		cell.configure(imageUrl: presenter.images[indexPath.item])
		
		return cell
	}
}

// MARK: - IDetailView

extension DetailViewController: IDetailView {
	func render(viewModel: DetailViewModel) {
		contentView.configure(
			isFavorite: viewModel.isFavorite,
			title: viewModel.eventInfo.title,
			dates: viewModel.eventInfo.dates,
			price: viewModel.eventInfo.price, 
			place: viewModel.eventInfo.place,
			address: viewModel.eventInfo.address,
			description: viewModel.eventInfo.description
		)
		contentView.activityIndicator.stopAnimating()
		contentView.contentStack.isHidden = false
	}
	
	func reloadImagesCollection() {
		contentView.imagesCollectionView.reloadData()
		self.view.setNeedsLayout()
	}
	
	func changeFavoriteIcon(isFavorite: Bool) {
		contentView.favoriteButton.tintColor = isFavorite ? .systemRed : .gray
	}
}
