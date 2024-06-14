//
//  CalendarView.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import UIKit

final class CalendarView: UIView {
	
	lazy var calendarView: UICalendarView = makeCalendarView()
	lazy var doneButton: UIButton = makeDoneButton()
	lazy var cancelButton: UIButton = makeCancelButton()
	
	private lazy var contentStack: UIStackView = makeContentStack()
	private lazy var buttonStack: UIStackView = makeButtonStack()
	private lazy var titleLabel: UILabel = makeTitleLabel()
	
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

private extension CalendarView {
	func setupUI() {
		backgroundColor = .systemBackground
	}
	
	func setupLayout() {
		addSubview(calendarView)
		
		NSLayoutConstraint.activate([
			calendarView.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Padding.normal),
			calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
		])
	}
	
	func makeContentStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [titleLabel, calendarView, buttonStack])
		stack.axis = .vertical
		stack.spacing = Sizes.Padding.normal
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeButtonStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [doneButton, cancelButton])
		stack.axis = .horizontal
		stack.spacing = Sizes.Padding.normal
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.text = L10n.CalendarScreen.title
		label.font = UIFont.boldSystemFont(ofSize: Sizes.Font.title)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeCalendarView() -> UICalendarView {
		let calendarView = UICalendarView()
		calendarView.calendar = .current
		calendarView.locale = .current
		calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
		calendarView.translatesAutoresizingMaskIntoConstraints = false
		return calendarView
	}
	
	func makeDoneButton() -> UIButton {
		let button = UIButton()
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.baseBackgroundColor = .systemBlue
		config.title = L10n.Common.done
		button.configuration = config
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func makeCancelButton() -> UIButton {
		let button = UIButton()
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.baseBackgroundColor = .systemRed
		config.title = L10n.Common.cancel
		button.configuration = config
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
