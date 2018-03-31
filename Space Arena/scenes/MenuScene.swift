//
//  scene2.swift
//  Space Arena
//
//  Created by Ever on 3/22/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import SpriteKit
import GameplayKit

var staminaCount = Int(20)


class MenuScene: SKScene {
	private var lastUpdateTime : TimeInterval = 0
	
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()

	let playButton = SKShapeNode(rect: CGRect(x: -250, y: -50, width: 500, height: 100), cornerRadius: 20)
	let play = SKLabelNode(text: "PLAY")
	
	let settingsButton = SKShapeNode(rect: CGRect(x: -45, y: -50, width: 90, height: 100), cornerRadius: 20)
	let settings = SKLabelNode(text: "⚙")
	
	let adButton = SKShapeNode(rect: CGRect(x: -45, y: -50, width: 90, height: 100), cornerRadius: 20)
	let ad = SKLabelNode(text: "AD")
	
	let playBotButton = SKShapeNode(rect: CGRect(x: -140, y: -50, width: 280, height: 100), cornerRadius: 20)
	let playBot = SKLabelNode(text: "PLAY BOT")
	
	let staminaBar = SKShapeNode(rect: CGRect(x: -440, y: -34, width: 884, height: 68), cornerRadius: 8)
	var staminaAmount = Int(0)
	let stamina = SKShapeNode(rect: CGRect(x: -20, y: -30, width: 40, height: 60), cornerRadius: 8)

	
	
	override func didMove(to view: SKView) {
		self.backgroundColor = UIColor.black
		let backgroundSound = SKAudioNode(fileNamed: "bg.mp3")
		self.addChild(backgroundSound)

		playButton.position = CGPoint(x: 0, y: 0)
		playButton.fillColor = UIColor.gray
		playButton.zPosition = 1
		play.position.x = playButton.position.x
		play.position.y = playButton.position.y-20
		play.fontName = "Menlo-BoldItalic"
		play.zPosition = 2
		play.fontSize = 64
		let playShadow = play.copy() as! SKLabelNode
		playShadow.position.x = play.position.x-5
		playShadow.position.y = play.position.y-5
		playShadow.zPosition = 1.9
		playShadow.fontColor = UIColor.darkGray
		addChild(playButton)
		addChild(play)
		addChild(playShadow)
		
		playBotButton.position = CGPoint(x: 0, y: -120)
		playBotButton.fillColor = UIColor.gray
		playBotButton.zPosition = 1
		playBot.position.x = playBotButton.position.x
		playBot.position.y = playBotButton.position.y-15
		playBot.fontName = "Menlo-BoldItalic"
		playBot.zPosition = 2
		playBot.fontSize = 45
		let playBotShadow = playBot.copy() as! SKLabelNode
		playBotShadow.position.x = playBot.position.x-5
		playBotShadow.position.y = playBot.position.y-5
		playBotShadow.zPosition = 1.9
		playBotShadow.fontColor = UIColor.darkGray
		addChild(playBotButton)
		addChild(playBot)
		addChild(playBotShadow)
		
		settingsButton.position = CGPoint(x: -205, y: -120)
		settingsButton.fillColor = UIColor.gray
		settingsButton.zPosition = 1
		settings.position.x = settingsButton.position.x
		settings.position.y = settingsButton.position.y-20
		settings.fontName = "Menlo-BoldItalic"
		settings.zPosition = 2
		settings.fontSize = 56
		addChild(settingsButton)
		addChild(settings)
		
		adButton.position = CGPoint(x: 205, y: -120)
		adButton.fillColor = UIColor.gray
		adButton.zPosition = 1
		ad.position.x = adButton.position.x
		ad.position.y = adButton.position.y-20
		ad.fontName = "Menlo-BoldItalic"
		ad.zPosition = 2
		ad.fontSize = 56
		let adShadow = ad.copy() as! SKLabelNode
		adShadow.position.x = ad.position.x-5
		adShadow.position.y = ad.position.y-5
		adShadow.zPosition = 1.9
		adShadow.fontColor = UIColor.darkGray
		addChild(adButton)
		addChild(ad)
		addChild(adShadow)


		stamina.fillColor = UIColor.yellow
		stamina.lineWidth = 0
		stamina.zPosition = 1
		staminaBar.position = CGPoint(x: 0, y: 200)
		staminaBar.zPosition = 0.9
		staminaBar.fillColor = UIColor.black
		
		addChild(staminaBar)
		
		func addStar() {
			let star = SKEmitterNode()
			star.position = CGPoint(x: 0, y: 0)
			star.particleSpeed = 80
			star.particleColor = UIColor.white
			star.particleScaleRange = 0.5
			star.particleSize = CGSize(width: 3, height: 3)
			star.emissionAngleRange = 10
			star.particleBirthRate = 40
			star.particleLifetime = 8
			star.physicsBody?.linearDamping = 0
			addChild(star)
		}
		
		func addStamina() {
			let staminaCopy = stamina.copy() as! SKShapeNode
			staminaCopy.position = CGPoint(x: (44*staminaAmount)-416, y: Int(staminaBar.position.y))
			if staminaCount>0 {
			addChild(staminaCopy)
			} else {}
			staminaAmount += 1
		}
		run(SKAction.repeat(SKAction.run(addStamina), count: staminaCount))
		run(SKAction.run(addStar))

	}
	
	func touchDownInPlayBotButton(atPoint pos : CGPoint) {
		if (staminaCount>=1){
		staminaCount -= 1
		let game = GameScene(fileNamed: "GameScene")
		game?.scaleMode = .aspectFill
		self.view?.presentScene(game!, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
		} else {
			let label1 = SKLabelNode(text: "Not Enough Stamina")
			label1.fontColor = UIColor.red
			label1.zPosition = 10
			label1.position = CGPoint(x: 0, y: 100)
			label1.fontName = "Menlo-BoldItalic"
			let action1 = SKAction.fadeIn(withDuration: 0.2)
			let action2 = SKAction.fadeOut(withDuration: 0.3)
			let action3 = SKAction.removeFromParent()
			let labelCopy = label1.copy() as! SKLabelNode
			addChild(labelCopy)
			labelCopy.run(SKAction.sequence([action1, action2, action3]))
		}
	}
	
	
	func touchDownInPlayButton(atPoint pos : CGPoint) {
		if (staminaCount>=2){
			staminaCount -= 2
			let loading = LoadingScreen(fileNamed: "LoadingScreen")
			loading?.scaleMode = .aspectFill
			self.view?.presentScene(loading!, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 0.5))
		} else {
			let label1 = SKLabelNode(text: "Not Enough Stamina")
			label1.fontColor = UIColor.red
			label1.zPosition = 10
			label1.position = CGPoint(x: 0, y: 100)
			label1.fontName = "Menlo-BoldItalic"
			let action1 = SKAction.fadeIn(withDuration: 0.2)
			let action2 = SKAction.fadeOut(withDuration: 0.3)
			let action3 = SKAction.removeFromParent()
			let labelCopy = label1.copy() as! SKLabelNode
			addChild(labelCopy)
			labelCopy.run(SKAction.sequence([action1, action2, action3]))		}
	}
	func touchDownInAdButton(atPoint pos : CGPoint) {
		let ad = AdScene(fileNamed: "ADScene")
		ad?.scaleMode = .aspectFill
		self.view?.presentScene(ad!, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 0.5))
	}
	func touchDownInSettingsButton(atPoint pos : CGPoint) {
		let settings = SettingsScene(fileNamed: "SettingsScene")
		settings?.scaleMode = .aspectFill
		self.view?.presentScene(settings!, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
	}
	
	var activeTouches:[SKShapeNode:UITouch] = [:]
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			if playBotButton.frame.contains(location) && activeTouches[playBotButton] == nil {
				touchDownInPlayBotButton(atPoint: location)
				//activeTouches[playBotButton]=touch
			}
			if playButton.frame.contains(location) && activeTouches[playButton] == nil {
				touchDownInPlayButton(atPoint: location)
				//activeTouches[playButton]=touch
			}
			if adButton.frame.contains(location) && activeTouches[adButton] == nil {
				touchDownInAdButton(atPoint: location)
				//activeTouches[adButton]=touch
			}
			if settingsButton.frame.contains(location) && activeTouches[settingsButton] == nil {
				touchDownInSettingsButton(atPoint: location)
				//activeTouches[settingsButton]=touch
			}
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		
		if (self.lastUpdateTime == 0) {
			self.lastUpdateTime = currentTime
		}
		// Calculate time since last update
		let dt = currentTime - self.lastUpdateTime
		// Update entities
		for entity in self.entities {
			entity.update(deltaTime: dt)
		}
		self.lastUpdateTime = currentTime
	}
}
