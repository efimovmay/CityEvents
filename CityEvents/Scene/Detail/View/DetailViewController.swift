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

// MARK: - SetupUI

private extension DetailViewController {
	func setupUI() {
		contentView.imagesCollectionView.dataSource = self
	}
}

// MARK: - SetupUI

extension DetailViewController: UICollectionViewDataSource {
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
			title: viewModel.title,
			dates: viewModel.dates,
			price: viewModel.price,
			address: viewModel.address,
			description: viewModel.description,
			siteUrl: viewModel.siteUrl
		)
	}
	
	func reloadImagesCollection() {
		contentView.imagesCollectionView.reloadData()
	}
}
