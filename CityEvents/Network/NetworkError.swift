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
