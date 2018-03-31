//
//  random.swift
//  Space Arena
//
//  Created by Ever on 3/11/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import CoreGraphics

func random() -> CGFloat {
	return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
	return random() * (max - min) + min
}

func randomInt(maxa: Int) -> Int {
	let n = Int(arc4random_uniform(UInt32(maxa)))
	return n
}
