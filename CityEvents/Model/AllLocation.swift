//
//  AllLocation.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

enum AllLocation: String {
	case spb = "spb"
	case msk = "msk"
	case nsk = "nsk"
	case ekb = "ekb"
	case nnv = "nnv"
	case kzn = "kzn"
	case bg = "bg"
	case smr = "smr"
	case krd = "krd"
	case sochi = "sochi"
	case ufa = "ufa"
	case krasnoyarsk = "krasnoyarsk"
	case kev = "kev"
	case newYork = "new-york"
	
	var description: String {
		switch self {
			
		case .spb:
			"Санкт-Петербург"
		case .msk:
			"Москва"
		case .nsk:
			"Новосибирск"
		case .ekb:
			"Екатеринбург"
		case .nnv:
			"Нижний Новгород"
		case .kzn:
			"Казань"
		case .bg:
			"Выборг"
		case .smr:
			"Самара"
		case .krd:
			"Краснодар"
		case .sochi:
			"Сочи"
		case .ufa:
			"Уфа"
		case .krasnoyarsk:
			"Красноярск"
		case .kev:
			"Киев"
		case .newYork:
			"Нью-Йорк"
		}
	}
}
