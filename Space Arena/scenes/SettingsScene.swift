//
//  SettingsScene.swift
//  Space Arena
//
//  Created by Ever on 3/28/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SettingsScene: SKScene {
	private var lastUpdateTime : TimeInterval = 0
	
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	
	let tutorialButton = SKShapeNode(rect: CGRect(x: -250, y: -50, width: 500, height: 100), cornerRadius: 20)
	let tutorial = SKLabelNode(text: "tutorial")

	let menuButton = SKShapeNode(rect: CGRect(x: -250, y: -50, width: 500, height: 100), cornerRadius: 20)
	let menu = SKLabelNode(text: "MENU")

	override func didMove(to view: SKView) {
		self.backgroundColor = UIColor.gray
		
		tutorialButton.position = CGPoint(x: 0, y: 55)
		tutorialButton.fillColor = UIColor.gray
		tutorialButton.zPosition = 1
		tutorial.position.x = tutorialButton.position.x
		tutorial.position.y = tutorialButton.position.y-20
		tutorial.fontName = "Menlo-BoldItalic"
		tutorial.zPosition = 2
		tutorial.fontSize = 64
		let tutorialShadow = tutorial.copy() as! SKLabelNode
		tutorialShadow.position.x = tutorial.position.x-5
		tutorialShadow.position.y = tutorial.position.y-5
		tutorialShadow.zPosition = 1.9
		tutorialShadow.fontColor = UIColor.darkGray
		addChild(tutorialButton)
		addChild(tutorial)
		addChild(tutorialShadow)
		
		menuButton.position = CGPoint(x: 0, y: -55)
		menuButton.fillColor = UIColor.gray
		menuButton.zPosition = 1
		menu.position.x = menuButton.position.x
		menu.position.y = menuButton.position.y-20
		menu.fontName = "Menlo-BoldItalic"
		menu.zPosition = 2
		menu.fontSize = 64
		let menuShadow = menu.copy() as! SKLabelNode
		menuShadow.position.x = menu.position.x-5
		menuShadow.position.y = menu.position.y-5
		menuShadow.zPosition = 1.9
		menuShadow.fontColor = UIColor.darkGray
		addChild(menuButton)
		addChild(menu)
		addChild(menuShadow)
	
	
	}
	
	func touchDownInTutorialButton(atPoint pos : CGPoint) {
			let tutorial = Tutorial(fileNamed: "Tutorial")
			tutorial?.scaleMode = .aspectFill
			self.view?.presentScene(tutorial!, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 0.5))
	}
	
	func touchDownInMenuButton(atPoint pos : CGPoint) {
		let menu = MenuScene(fileNamed: "MenuScene")
		menu?.scaleMode = .aspectFill
		self.view?.presentScene(menu!, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)

			if menuButton.frame.contains(location) {
				touchDownInMenuButton(atPoint: location)
			}

			if tutorialButton.frame.contains(location) {
				touchDownInTutorialButton(atPoint: location)
			}
		}
	}
}
