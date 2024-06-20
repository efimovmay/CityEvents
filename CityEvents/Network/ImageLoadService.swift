//
//  ImageLoadService.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 19.06.2024.
//

import UIKit

protocol IImageLoadService {
	
	/// Загрузка изображения.
	/// - Parameters:
	/// - url: Адрес изображения
	func fetchImage(at url: String, completion: @escaping (Data?) -> Void)
}

final class ImageLoadService: IImageLoadService {
	
	var network: INetworkService?
	private lazy var imageCahe = NSCache<NSString, NSData>()
	
	// MARK: - Public methods
	
	func fetchImage(at urlString: String, completion: @escaping (Data?) -> Void) {
		if let imageData = imageCahe.object(forKey: urlString as NSString) as? Data  {
			completion(imageData)
			return
		}
		guard let url = URL(string: urlString) else {
			completion(nil)
			return
		}
		let request = URLRequest(url: url)
		network?.perform(request: request) { result in
			switch result {
			case .success(let data):
				if let image = UIImage(data: data),
				   let imageCompress = self.aspectFittedToHeight(image: image, newHeight: 300) {
					self.imageCahe.setObject(imageCompress as NSData, forKey: urlString as NSString)
					completion(imageCompress)
				} else {
					completion(nil)
				}
			case .failure(_):
				completion(nil)
				return
			}
		}
	}
}

// MARK: - Private methods

private extension ImageLoadService {
	
	func aspectFittedToHeight(image: UIImage, newHeight: CGFloat) -> Data? {
		let scale = newHeight / image.size.height
		let newWidth = image.size.width * scale
		let newSize = CGSize(width: newWidth, height: newHeight)
		let renderer = UIGraphicsImageRenderer(size: newSize)
		
		let resizedImage = renderer.image { _ in
			image.draw(in: CGRect(origin: .zero, size: newSize))
		}
		return resizedImage.jpegData(compressionQuality: 0.8)
	}
}
