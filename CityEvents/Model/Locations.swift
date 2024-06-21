//
//  Locations.swift
//  CityEvents
//
//  Created by Aleksey Efimov on 09.06.2024.
//

import Foundation

enum Locations: String, CaseIterable {
	case spb = "spb"
	case msk = "msk"
	case nsk = "nsk"
	case ekb = "ekb"
	case nnv = "nnv"
	case kzn = "kzn"
	case krd = "krd"
	case sochi = "sochi"
	case ufa = "ufa"
	case krasnoyarsk = "krasnoyarsk"
	case kev = "kev"
	case newYork = "new-york"
	
	var description: String {
		switch self {
		case .spb:
			L10n.Location.spb
		case .msk:
			L10n.Location.msk
		case .nsk:
			L10n.Location.nsk
		case .ekb:
			L10n.Location.ekb
		case .nnv:
			L10n.Location.nnv
		case .kzn:
			L10n.Location.kzn
		case .krd:
			L10n.Location.krd
		case .sochi:
			L10n.Location.sochi
		case .ufa:
			L10n.Location.ufa
		case .krasnoyarsk:
			L10n.Location.krasnoyarsk
		case .kev:
			L10n.Location.kev
		case .newYork:
			L10n.Location.newYork
		}
	}
}
