//
//  LoadingScreen.swift
//  Space Arena
//
//  Created by Ever on 3/28/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LoadingScreen: SKScene {
	private var lastUpdateTime : TimeInterval = 0
	
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	
	override func didMove(to view: SKView) {
		self.backgroundColor = UIColor.blue
		let label = SKLabelNode(text: "Loading Screen")
		addChild(label)
		let backgroundSound = SKAudioNode(fileNamed: "loading.mp3")
		self.addChild(backgroundSound)
		func changeScene() {
			let online = PlayOnline(fileNamed: "PlayOnline")
			online?.scaleMode = .aspectFill
			self.view?.presentScene(online!, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
		}
		let action1 = SKAction.wait(forDuration: 0.5)
		let action2 = SKAction.run(changeScene)
		run(SKAction.sequence([action1, action2]))
	}
}
