//
//  DeathScene.swift
//  Space Arena
//
//  Created by Ever on 3/26/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//


import SpriteKit
import GameplayKit
import GoogleMobileAds

var enemyShotsFired:Int = 0
var playerShotsFired:Int = 0
var playerShotsHit:Int = 0
var enemyShotsHit:Int = 0
var enemyDamageDealt:Int = 0
var playerDamageDealt:Int = 0


class DeathScene: SKScene {
	private var lastUpdateTime : TimeInterval = 0

	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	
	let menuButton = SKShapeNode(rect: CGRect(x: -125, y: -25, width: 250, height: 50), cornerRadius: 5)
	let menu = SKLabelNode(text: "MENU")
	
	let BannerAD = GADBannerView(adSize: kGADAdSizeBanner)
	
	override func didMove(to view: SKView) {
		var matchLength:Int = Int(timeElapsed)

		let statESF = SKLabelNode(text: "Enemy Shots Fired: \(enemyShotsFired)")
		let statPSF = SKLabelNode(text: "Player Shots Fired: \(playerShotsFired)")
		let statESH = SKLabelNode(text: "Enemy Shots Hit: \(enemyShotsHit)")
		let statPSH = SKLabelNode(text: "Player Shots Hit: \(playerShotsHit)")
		let statML = SKLabelNode(text: "Match Length: \(matchLength) seconds")

		let backgroundSound = SKAudioNode(fileNamed: "deathScene.mp3")
		self.addChild(backgroundSound)
		statML.position = CGPoint(x: 0, y: 150)
		statML.fontName = "Menlo-Bold"
		statML.fontSize = 24
		addChild(statML)
		
		statESF.position = CGPoint(x: 0, y: 125)
		statESF.fontName = "Menlo-Bold"
		statESF.fontSize = 24
		addChild(statESF)
		
		statPSF.position = CGPoint(x: 0, y: 100)
		statPSF.fontName = "Menlo-Bold"
		statPSF.fontSize = 24
		addChild(statPSF)
		
		statESH.position = CGPoint(x: 0, y: 75)
		statESH.fontName = "Menlo-Bold"
		statESH.fontSize = 24
		addChild(statESH)
		
		statPSH.position = CGPoint(x: 0, y: 50)
		statPSH.fontName = "Menlo-Bold"
		statPSH.fontSize = 24
		addChild(statPSH)

		self.backgroundColor = UIColor.black
		menuButton.position = CGPoint(x: 0, y: 0)
		menuButton.fillColor = UIColor.gray
		menuButton.zPosition = 1
		addChild(menuButton)

		menu.position.x = menuButton.position.x
		menu.position.y = menuButton.position.y-11
		menu.fontName = "Menlo-BoldItalic"
		menu.zPosition = 2
		addChild(menu)

		guard let controller = self.view?.window?.rootViewController as? GameViewController else {return}

		BannerAD.frame = CGRect(x: 140, y: 200, width: 320, height: 50)
		BannerAD.delegate = self as? GADBannerViewDelegate
		BannerAD.adUnitID = "ca-app-pub-3940256099942544/2934735716"
		BannerAD.rootViewController = controller
		let request = GADRequest()
		request.testDevices = [kGADSimulatorID, "17755764fa910e4757b4728865f6217b"]
		
		BannerAD.load(request)
		view.addSubview(BannerAD)
		
	}
	
	func touchDownInMenuButton(atPoint pos : CGPoint) {
		let menu = MenuScene(fileNamed: "MenuScene")
		menu?.scaleMode = .aspectFill
		self.view?.presentScene(menu!, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
		BannerAD.removeFromSuperview()
	}
	
	var activeTouches:[SKShapeNode:UITouch] = [:]
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			if menuButton.frame.contains(location) && activeTouches[menuButton] == nil {
				touchDownInMenuButton(atPoint: location)
				activeTouches[menuButton]=touch
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


