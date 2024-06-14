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
	
	private lazy var contentStack: UIStackView = makeContentStack()
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
		addSubview(contentStack)
		
		NSLayoutConstraint.activate([
			contentStack.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Padding.normal),
			contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Padding.normal),
			contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Padding.normal),
			
			titleLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
			
			doneButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5),
			doneButton.heightAnchor.constraint(equalToConstant: Sizes.CalendarScreen.doneButtonHeith),
		])
	}
	
	func makeContentStack() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [titleLabel, calendarView, doneButton])
		stack.axis = .vertical
		stack.alignment = .center
		stack.distribution = .fill
		stack.spacing = Sizes.Padding.normal
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}
	
	func makeTitleLabel() -> UILabel {
		let label = UILabel()
		label.text = L10n.CalendarScreen.title
		label.font = UIFont.boldSystemFont(ofSize: Sizes.Font.title)
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	func makeCalendarView() -> UICalendarView {
		let calendarView = UICalendarView()
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
		config.attributedTitle = AttributedString(L10n.Common.done, attributes: AttributeContainer([
			NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: Sizes.Font.regular)
		]))
		button.configuration = config

		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}
