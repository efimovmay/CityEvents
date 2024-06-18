//
//  NetworkService.swift
//
//  Created by Aleksey Efimov on 30.05.2024.
//

import Foundation

protocol INetworkService {

	func fetch<T: Decodable>(
		dataType: T.Type,
		with requestData: INetworkRequestData,
		completion: @escaping(Result<T, NetworkServiceError>) -> Void
	)
	
	func fetch<T: Decodable>(
		dataType: T.Type,
		url: String,
		completion: @escaping(Result<T, NetworkServiceError>) -> Void
	)
	
	func perform(
		request: URLRequest,
		completion: @escaping (Result<Data, NetworkServiceError>
		) -> Void)
}

class NetworkService: INetworkService {
	
	private let decoder = JSONDecoder()
	private let session = URLSession.shared
	
	func fetch<T: Decodable>(
		dataType: T.Type,
		with requestData: INetworkRequestData,
		completion: @escaping(Result<T, NetworkServiceError>) -> Void
	) {
		guard let request = makeRequest(with: requestData) else {
			completion(.failure(.invalidURL))
			return
		}
		perform(request: request) { result in
			switch result {
			case .success(let data):
				do {
					let result = try self.decoder.decode(T.self, from: data)
					completion(.success(result))
				} catch {
					completion(.failure(.failedToDecodeResponse(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func fetch<T: Decodable>(
		dataType: T.Type,
		url: String,
		completion: @escaping(Result<T, NetworkServiceError>) -> Void
	) {
		guard let url = URL(string: url) else {
			completion(.failure(.invalidURL))
			return
		}
		let request = URLRequest(url: url)
		
		perform(request: request) { result in
			switch result {
			case .success(let data):
				do {
					let result = try self.decoder.decode(T.self, from: data)
					completion(.success(result))
				} catch {
					completion(.failure(.failedToDecodeResponse(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func perform(
		request: URLRequest,
		completion: @escaping (Result<Data, NetworkServiceError>
		) -> Void) {
		session.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(.networkError(error)))
			}
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(.invalidResponse))
				return
			}
			guard (200...299).contains(httpResponse.statusCode) else {
				completion(.failure(.invalidStatusCode(httpResponse.statusCode)))
				return
			}
			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			completion(.success(data))
		}.resume()
	}
}

private extension NetworkService {
	
	func makeRequest(with requestData: INetworkRequestData) -> URLRequest? {
		
		guard var urlComponents = URLComponents(string: NetworkEndpoints.baseURL) else {
			return nil
		}
		urlComponents.path = requestData.path
		urlComponents.queryItems = requestData.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		guard let url = urlComponents.url else {
			return nil
		}
		var request = URLRequest(url: url)
		request.httpMethod = requestData.method.rawValue
		
		return request
	}
}
