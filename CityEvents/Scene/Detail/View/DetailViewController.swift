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
	func setImage(dataImage: Data?, indexItem: Int)
	func showDownloadEnd()
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
		navigationItem.largeTitleDisplayMode = .never
		
		contentView.imagesCollectionView.dataSource = self
		contentView.onSiteButton.addTarget(self, action: #selector(onSiteButtonPressed), for: .touchUpInside)
		contentView.favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
	}
}

// MARK: - UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let count = presenter.getImagesCount()
		contentView.pageControl.numberOfPages = count
		contentView.pageControl.isHidden = count <= 1
		
		return count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: DetailImageCell.identifier,
			for: indexPath
		) as? DetailImageCell else { return UICollectionViewCell() }
		let image = presenter.getImageAtIndex(indexPath.item)
		cell.activityIndicator.startAnimating()
		presenter.loadImage(from: image, index: indexPath.item)
		
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
	}
	
	func changeFavoriteIcon(isFavorite: Bool) {
		contentView.favoriteButton.tintColor = isFavorite ? .systemRed : .gray
	}
	
	func showDownloadEnd() {
		contentView.activityIndicator.stopAnimating()
	}
	
	func setImage(dataImage: Data?, indexItem: Int) {
		let indexPath = IndexPath(item: indexItem, section: .zero)
		guard let cell = contentView.imagesCollectionView.cellForItem(at: indexPath) as? DetailImageCell else { return }
		cell.activityIndicator.stopAnimating()
		if let dataImage = dataImage {
			cell.eventImageView.contentMode = .scaleAspectFill
			cell.eventImageView.image = UIImage(data: dataImage)
		} else {
			cell.eventImageView.contentMode = .center
			cell.eventImageView.image = Theme.ImageIcon.imageFail
		}
	}
}
