//
//  CalendarViewController.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 13.06.2024.
//

import UIKit

final class CalendarViewController: UIViewController {
	
	private let presenter: ICalendarPresenter
	private lazy var contentView = CalendarView()
	
	private var startDate: Date? = nil
	private var endDate: Date? = nil
	
	init(presenter: ICalendarPresenter) {
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

private extension CalendarViewController {
	@objc
	func doneButtonTaped() {
		presenter.dateSetDone(startDate: startDate, endDate: endDate)
	}
	
	func setupUI() {
		contentView.doneButton.addTarget(self, action: #selector(doneButtonTaped), for: .touchUpInside)
		contentView.calendarView.selectionBehavior = UICalendarSelectionMultiDate(delegate: self)
		contentView.calendarView.isUserInteractionEnabled = true
	}
	
	func getDateRange() -> [DateComponents] {
		guard let startDate = startDate, let endDate = endDate else { return [] }
		
		var dates = [DateComponents]()
		var currentDate = startDate
		
		while currentDate <= endDate {
			dates.append(Calendar.current.dateComponents([.year, .month, .day], from: currentDate))
			guard let date = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { return [] }
			currentDate = date
		}
		return dates
	}
}

extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionMultiDateDelegate {
	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
		guard var selectedDate = Calendar.current.date(from: dateComponents) else { return }
		selectedDate.addTimeInterval(3 * 60 * 60)
		
		if startDate == nil {
			startDate = selectedDate
			selection.setSelectedDates([dateComponents], animated: false)
		} else if endDate == nil {
			guard let startDate = startDate else { return }
			if selectedDate < startDate {
				self.startDate = selectedDate
				selection.setSelectedDates([dateComponents], animated: false)
			} else {
				endDate = selectedDate.addingTimeInterval(23 * 60 * 60)
				selection.setSelectedDates(getDateRange(), animated: false)
			}
		} else {
			startDate = nil
			endDate = nil
			selection.setSelectedDates([], animated: true)
		}
	}
	
	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
		selection.setSelectedDates([], animated: true)
	}
	
	func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
		true
	}
}
