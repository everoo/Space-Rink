//
//  Tutorial.swift
//  Space Arena
//
//  Created by Ever on 3/30/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Tutorial: SKScene {
	private var lastUpdateTime : TimeInterval = 0
	
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	
	let image1 = SKSpriteNode(imageNamed: "tutorial1")
	let image2 = SKSpriteNode(imageNamed: "tutorial2")
	let image3 = SKSpriteNode(imageNamed: "tutorial3")
	
	var imageNum:Int = 0

	func addImage() {
		if imageNum==0 {
			imageNum+=1
			image1.size = CGSize(width: 710, height: 400)
			image1.zPosition = 1
			addChild(image1)
		} else if imageNum==1 {
			imageNum+=1
			image2.size = CGSize(width: 710, height: 400)
			image2.zPosition = 2
			addChild(image2)
		} else if imageNum==2 {
			imageNum+=1
			image3.size = CGSize(width: 710, height: 400)
			image3.zPosition = 3
			addChild(image3)
		} else {
			let settings = SettingsScene(fileNamed: "SettingsScene")
			settings?.scaleMode = .aspectFill
			self.view?.presentScene(settings!, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 0.5))

		}
	}
	
	override func didMove(to view: SKView) {
		self.backgroundColor = UIColor.black
		let label = SKLabelNode(text: "Tap to continue")
		label.zPosition = 0
		addChild(label)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		addImage()
	}
}
