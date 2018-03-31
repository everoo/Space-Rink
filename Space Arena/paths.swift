//
//  paths.swift
//  Space Arena
//
//  Created by Ever on 3/11/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import CoreGraphics
//let scaler = Int(2)

func pathOfShip(_ rect: CGRect, scaler: Int) -> CGPath{
	let path = CGMutablePath()
	path.move(to: CGPoint(x: -9*scaler, y: 6*scaler))
	path.addLine(to: CGPoint(x: -9*scaler, y: -4*scaler))
	path.addQuadCurve(to: CGPoint(x: -5*scaler, y: -10*scaler), control: CGPoint(x: -9*scaler, y: -9*scaler))
	path.addLine(to: CGPoint(x: 5*scaler, y: -10*scaler))
	path.addQuadCurve(to: CGPoint(x: 9*scaler, y: -4*scaler), control: CGPoint(x: 9*scaler, y: -9*scaler))
	path.addLine(to: CGPoint(x: 9*scaler, y: 6*scaler))
	path.addQuadCurve(to: CGPoint(x: 5*scaler, y: -4*scaler), control: CGPoint(x: 7*scaler, y: -9*scaler))
	path.addLine(to: CGPoint(x: 5*scaler, y: 4*scaler))
	path.addLine(to: CGPoint(x: 1*scaler, y: 6*scaler))
	path.addLine(to: CGPoint(x: 1*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: -1*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: -1*scaler, y: 6*scaler))
	path.addLine(to: CGPoint(x: -5*scaler, y: 4*scaler))
	path.addLine(to: CGPoint(x: -5*scaler, y: -4*scaler))
	path.addQuadCurve(to: CGPoint(x: -9*scaler, y: 6*scaler), control: CGPoint(x: -7*scaler, y: -9*scaler))
	path.closeSubpath()
	return path
}

func pathOfAsteroid(_ rect: CGRect, scaler: Int) -> CGPath {
	let path = CGMutablePath()
	let a = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let b = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let c = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let d = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let e = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let f = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let g = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let h = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let i = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let j = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let k = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	let l = random(min: CGFloat(2*scaler), max: CGFloat(50*scaler))
	path.move(to: CGPoint(x: 0, y: a))
	path.addLine(to: CGPoint(x: -b, y: c))
	path.addLine(to: CGPoint(x: -d, y: 0))
	path.addLine(to: CGPoint(x: -e, y: -f))
	path.addLine(to: CGPoint(x: 0, y: -g))
	path.addLine(to: CGPoint(x: h, y: -i))
	path.addLine(to: CGPoint(x: j, y: 0))
	path.addLine(to: CGPoint(x: k, y: l))
	path.closeSubpath()
	return path
}

func pathOfForceField(_ rect: CGRect, scaler: CGFloat) -> CGPath {
	let path = CGMutablePath()
	path.addArc(center: CGPoint(x: 0,y: 0), radius: scaler, startAngle: 0, endAngle: 1, clockwise: true)
	path.addArc(center: CGPoint(x: 0,y: 0), radius: scaler, startAngle: 1, endAngle: 0, clockwise: true)
	path.closeSubpath()
	return path
}

func pathOfForceFieldUpgrade(_ rect: CGRect, scaler: CGFloat) -> CGPath {
	let path = CGMutablePath()
	path.addArc(center: CGPoint(x: 0,y: 0), radius: 8*scaler, startAngle: 0, endAngle: 1, clockwise: true)
	path.addArc(center: CGPoint(x: 0,y: 0), radius: 8*scaler, startAngle: 1, endAngle: 0, clockwise: true)
	path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.closeSubpath()
	return path
}

func pathOfMedPack(_ rect: CGRect, scaler: Int) -> CGPath {
	let path = CGMutablePath()
	path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.move(to: CGPoint(x: 0*scaler, y: -7*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
	path.move(to: CGPoint(x: -7*scaler, y: 0*scaler))
	path.addLine(to: CGPoint(x: 7*scaler, y: 0*scaler))
	path.closeSubpath()
	return path
}

func pathOfArrow(_ rect: CGRect, scaler: Int) -> CGPath {
	let path = CGMutablePath()
	path.move(to: CGPoint(x: -3*scaler, y: 0*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: 2*scaler))
	path.addLine(to: CGPoint(x: 3*scaler, y: 0*scaler))
	return path
}

func pathOfMissile(_ rect: CGRect, scaler: Int) -> CGPath {
	let path = CGMutablePath()
	path.move(to: CGPoint(x: 0*scaler, y: 7*scaler))
	path.addLine(to: CGPoint(x: 6*scaler, y: -7*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: -2*scaler))
	path.addLine(to: CGPoint(x: -6*scaler, y: -7*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
	path.closeSubpath()
	return path
}

func pathOfMissileUpgrade(_ rect: CGRect, scaler: Int) -> CGPath {
	let path = CGMutablePath()
	path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
	path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
	path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
	path.move(to: CGPoint(x: 0*scaler, y: 7*scaler))
	path.addLine(to: CGPoint(x: 6*scaler, y: -7*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: -2*scaler))
	path.addLine(to: CGPoint(x: -6*scaler, y: -7*scaler))
	path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
	path.closeSubpath()
	return path
}
