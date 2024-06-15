//
//  LocationViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

final class LocationViewController: UIViewController {
	
	private let presenter: ILocationPresenter
	private lazy var contentView = LocationView()
	
	init(presenter: ILocationPresenter) {
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
	}
}

private extension LocationViewController {
	func setupUI() {
		contentView.locationTableView.delegate = self
		contentView.locationTableView.dataSource = self
	}
}

extension LocationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.getLocationsCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: LocationView.cellIdentifier, for: indexPath)
		
		let location = presenter.getLocationAtIndex(indexPath.row)
		
		var config = cell.defaultContentConfiguration()
		config.text = location.description
		cell.contentConfiguration = config
		cell.selectionStyle = .none
		
		return cell
	}
}

extension LocationViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.LocationSetDone(index: indexPath.row)
	}
}
