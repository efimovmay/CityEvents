//
//  UIImageView+load+cache.swift
//
//  Created by Aleksey Efimov on 01.04.2024.
//

import UIKit

var imageCahe = NSCache<NSString, UIImage>()

extension UIImageView {
	
	func load(urlString: String, completion: @escaping () -> Void) {
		
		if let image = imageCahe.object(forKey: urlString as NSString) {
			self.image = image
			completion()
			return
		}
		guard let url = URL(string: urlString) else {
			return
		}
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					let imageCompress = image.size.height > 200 ? image.aspectFittedToHeight(200) : image
					DispatchQueue.main.async {
						imageCahe.setObject(imageCompress, forKey: urlString as NSString)
						self?.image = imageCompress
						completion()
					}
				}
			}
		}
	}
}
