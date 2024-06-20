//
//  NetworkError.swift
//
//  Created by Aleksey Efimov on 20.05.2024.
//

import Foundation

/// Ошибки сетевого слоя.
enum NetworkServiceError: Error {
	/// Ошибка URL.
	case invalidURL
	/// Сетевая ошибка.
	case networkError(Error)
	/// Ответ сервера имеет неожиданный формат.
	case invalidResponse
	/// Статус кода ответа, который не входит в диапазон успешных `(200..<300)`.
	case invalidStatusCode(Int)
	/// Данные отсутствуют.
	case noData
	/// Не удалось декодировать ответ.
	case failedToDecodeResponse(Error)
}

extension NetworkServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return L10n.networkError.invalidURL
		case .networkError:
			return L10n.networkError.networkError
		case .invalidResponse:
			return L10n.networkError.invalidResponse
		case .invalidStatusCode(let code):
			return "\(L10n.networkError.invalidStatusCode) (\(code))"
		case .noData:
			return L10n.networkError.noData
		case .failedToDecodeResponse:
			return L10n.networkError.failedToDecodeResponse
		}
	}
}
