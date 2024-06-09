//
//  UIImageView+load+cache.swift
//
//  Created by Aleksey Efimov on 01.04.2024.
//

import UIKit

var imageCahe = NSCache<AnyObject, AnyObject>()

extension UIImageView {
	func load(urlString: String, completion: @escaping () -> Void) {
		
		if let image = imageCahe.object(forKey: urlString as NSString) as? UIImage {
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
					DispatchQueue.main.async {
						imageCahe.setObject(image, forKey: urlString as NSString)
						self?.image = image
						completion()
					}
				}
			}
		}
	}
}
