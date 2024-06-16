//
//  DetailViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

protocol IDetailView: AnyObject {
	func render(viewModel: DetailViewModel)
}

final class DetailViewController: UIViewController {
	
	private let presenter: IDetailPresenter
	private lazy var contentView = DetailView()
	
	init(presenter: IDetailPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
		presenter.viewIsReady(view: self)
	}
}

private extension DetailViewController {
	func setupUI() {

	}
}


extension DetailViewController: IDetailView {
	func render(viewModel: DetailViewModel) {
		var string: String = ""
		viewModel.date.forEach { date in
			string.append("\(date) \n")
		}
		contentView.text.text = string
	}
}
