//
//  PlayOnline.swift
//  Space Arena
//
//  Created by Ever on 3/28/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import Firebase

class PlayOnline: SKScene {
	private var lastUpdateTime : TimeInterval = 0

	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()

	override func didMove(to view: SKView) {
		self.backgroundColor = UIColor.gray
		let backgroundSound = SKAudioNode(fileNamed: "loading.mp3")
		self.addChild(backgroundSound)
		let label = SKLabelNode(text: "Online Mode")
		addChild(label)
		func changeScene() {
			let death = DeathScene(fileNamed: "DeathScene")
			death?.scaleMode = .aspectFill
			self.view?.presentScene(death!, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 0.5))
		}
		let action1 = SKAction.wait(forDuration: 0.5)
		let action2 = SKAction.run(changeScene)
		run(SKAction.sequence([action1, action2]))
	}
}
