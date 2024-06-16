//
//  DetailPresenter.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import Foundation

protocol IDetailPresenter {
	func viewIsReady(view: IDetailView)
}

final class DetailPresenter: IDetailPresenter {
	
	private weak var view: IDetailView?
	private let router: IDetailRouter
	private let network: INetworkService
	private let idEvent: Int
	
	init(router: IDetailRouter, network: INetworkService, idEvent: Int) {
		self.router = router
		self.network = network
		self.idEvent = idEvent
	}
	
	func viewIsReady(view: IDetailView) {
		self.view = view
		fetchEvent()
	}
}

private extension DetailPresenter {
	func fetchEvent() {
		network.fetch(
			dataType: EventDTO.self,
			with: NetworkRequestDataDetailEvent(idEvent: idEvent)) { result in
				switch result {
				case .success(let data):
					self.renderData(data: data)
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
	}
	
	func renderData(data: EventDTO) {
		DispatchQueue.main.async {
			self.view?.render(viewModel: self.decodeUnicodeString(data.description))
		}
	}
	
	func decodeUnicodeString(_ unicodeString: String) -> String? {
		let cleanedString = removeImageTags(from: unicodeString)
		guard let data = cleanedString.data(using: .utf8) else { return nil }

		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]
		
		guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
		return attributedString.string
	}
	
	func removeImageTags(from htmlString: String) -> String {
		let pattern = "<img\\b[^>]*>"
		guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return htmlString }
		let modifiedString = regex.stringByReplacingMatches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.count), withTemplate: "")
		
		return modifiedString
	}
}
