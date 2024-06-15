//
//  UIImage+Compress.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 15.06.2024.
//

import UIKit

extension UIImage {
	
	func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
		let scale = newHeight / self.size.height
		let newWidth = self.size.width * scale
		let newSize = CGSize(width: newWidth, height: newHeight)
		let renderer = UIGraphicsImageRenderer(size: newSize)
		
		return renderer.image { _ in
			self.draw(in: CGRect(origin: .zero, size: newSize))
		}
	}
}
