//
//  FavoriteViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 18.06.2024.
//

import UIKit

protocol IFavoriteView: AnyObject {
	
}

final class FavoriteViewController: UIViewController {
	
	private let presenter: IFavoritePresenter
	private lazy var contentView = FavoriteView()
	
	// MARK: - Initialization
	
	init(presenter: IFavoritePresenter) {
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

private extension FavoriteViewController {
	func setupUI() {

	}
}

extension FavoriteViewController: IFavoriteView {
	
}
