//
//  GameScene.swift
//  Space Arena
//
//  Created by Ever on 2/24/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
	static let none:UInt32 = 				0
	static let asteroid:UInt32 = 			1
	static let enemyBullet:UInt32 = 		2
	static let playerBullet:UInt32 = 		4
	static let enemy:UInt32 = 				8
	static let player:UInt32 = 				16
	static let boundary:UInt32 =			32
	static let medPack:UInt32 = 			64
	static let forceField:UInt32 = 			128
	static let forceFieldUpgrade:UInt32 = 	256
	static let missileUpgrade:UInt32 = 		512
	static let missile:UInt32 = 			1024
	static let all:UInt32 = 				UInt32.max
}

var timeElapsed:Double = 0


class GameScene: SKScene, SKPhysicsContactDelegate {
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	private var lastUpdateTime : TimeInterval = 0
	
	let ball = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100))
	let base = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
	let healthBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 750, height: 11))
	let arrow = SKShapeNode(path: pathOfArrow(CGRect(x: 0, y: 0, width: 1, height: 1), scaler: 2))
	
	let player = SKShapeNode()
	let enemy = SKShapeNode()
	var asteroid : SKShapeNode?
	var bullet : SKShapeNode?
	var forceField : SKShapeNode?
	var missile : SKShapeNode?
	
	var medPack : SKShapeNode?
	var forceFieldUpgrade : SKShapeNode?
	var missileUpgrade : SKShapeNode?

	var cam: SKCameraNode?
	
	let leftSide = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 375, height: 1000))
	let rightSide = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 375, height: 1000))
	
	var health = CGFloat(1)
	var baseTouchBeganPos = CGPoint()
	var ballTouchMovedPos = CGPoint()
	var touchMovedPos = CGPoint()
	
	override func sceneDidLoad() {
		let backgroundSound = SKAudioNode(fileNamed: "BGGS.mp3")
		backgroundSound.isPositional = false
		backgroundSound.autoplayLooped = true
		self.addChild(backgroundSound)
		timeElapsed = 0
		enemyShotsFired = 0
		playerShotsFired = 0
		playerShotsHit = 0
		enemyShotsHit = 0
		enemyDamageDealt = 0
		playerDamageDealt = 0

		
		self.size = CGSize(width: 1500, height: 1500)
		cam = SKCameraNode()
		self.camera = cam
		self.addChild(cam!)
		cam?.xScale = 0.5
		cam?.yScale = 0.5
		self.backgroundColor = UIColor.black
		self.lastUpdateTime = 0
		self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
		self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		self.physicsWorld.contactDelegate = self
		self.physicsBody?.categoryBitMask = PhysicsCategory.boundary
		self.physicsBody?.collisionBitMask = PhysicsCategory.player | PhysicsCategory.enemy
		self.physicsBody?.contactTestBitMask = PhysicsCategory.none

		
		self.bullet = SKShapeNode.init(ellipseOf: CGSize(width: 10, height: 10))
		if let bullet = self.bullet{
			bullet.lineWidth = 2
			bullet.fillColor = UIColor.gray
			bullet.zPosition = 0.2
			bullet.physicsBody = SKPhysicsBody(polygonFrom: bullet.path!)
			bullet.physicsBody?.linearDamping = 0
			bullet.physicsBody?.allowsRotation = false
		}
		
		self.medPack = SKShapeNode()
		if let medPack = self.medPack {
			medPack.fillColor = UIColor.black
			medPack.strokeColor = UIColor.white
			medPack.lineWidth = 5
			medPack.zPosition = 0
		}
		
		self.forceFieldUpgrade = SKShapeNode()
		if let forceFieldUpgrade = self.forceFieldUpgrade {
			forceFieldUpgrade.fillColor = UIColor.black
			forceFieldUpgrade.strokeColor = UIColor.white
			forceFieldUpgrade.lineWidth = 5
			forceFieldUpgrade.zPosition = 0
		}
		
		self.forceField = SKShapeNode()
		if let forceField = self.forceField {
			forceField.fillColor = UIColor.clear
			forceField.strokeColor = UIColor.blue
			forceField.alpha = 0.8
			forceField.lineWidth = 2
			forceField.zPosition = 5
		}
		self.missileUpgrade = SKShapeNode()
		if let missileUpgrade = self.missileUpgrade {
			missileUpgrade.fillColor = UIColor.black
			missileUpgrade.strokeColor = UIColor.white
			missileUpgrade.lineWidth = 5
			missileUpgrade.zPosition = 0
		}
		
		self.missile = SKShapeNode()
		if let missile = self.missile {
			missile.fillColor = UIColor.red
			missile.strokeColor = UIColor.red
			missile.lineWidth = 2
			missile.zPosition = 5
		}
		
		self.asteroid = SKShapeNode()
		if let asteroid = self.asteroid {
			asteroid.fillColor = UIColor.black
			asteroid.strokeColor = UIColor.gray
			asteroid.lineWidth = 5
			asteroid.zPosition = 0.4
			asteroid.physicsBody?.linearDamping = 0
		}

		func addAsteroid() {
			if let asteroidCopy = self.asteroid?.copy() as! SKShapeNode? {
				self.addChild(asteroidCopy)
				asteroidCopy.path = pathOfAsteroid(CGRect(x: 0, y: 0, width: 1, height: 1), scaler: 2)
				asteroidCopy.physicsBody = SKPhysicsBody(polygonFrom: asteroidCopy.path!)
				asteroidCopy.physicsBody?.angularVelocity = random(min: 2, max: 10)
				asteroidCopy.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
				asteroidCopy.physicsBody?.collisionBitMask = PhysicsCategory.player | PhysicsCategory.enemy | PhysicsCategory.playerBullet | PhysicsCategory.enemyBullet | PhysicsCategory.asteroid
				asteroidCopy.physicsBody?.contactTestBitMask = PhysicsCategory.none
				let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
				let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
				asteroidCopy.position = CGPoint(x: actualX, y: actualY)
				asteroidCopy.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100), dy: random(min: -100, max: 100))
				let actionMove = SKAction.wait(forDuration: TimeInterval(30))
				let actionMoveDone = SKAction.removeFromParent()
				asteroidCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
			}
		}
		
		func addMedPack() {
			if let medPackCopy = self.medPack?.copy() as! SKShapeNode? {
				let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
				self.addChild(medPackCopy)
				medPackCopy.path = pathOfMedPack(rect, scaler: 2)
				let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
				let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
				medPackCopy.position = CGPoint(x: actualX, y: actualY)
				let actionMove = SKAction.wait(forDuration: TimeInterval(10))
				let actionMoveDone = SKAction.removeFromParent()
				medPackCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
				medPackCopy.physicsBody = SKPhysicsBody(polygonFrom: pathOfMedPack(rect, scaler: 2))
				medPackCopy.physicsBody?.categoryBitMask = PhysicsCategory.medPack
				medPackCopy.physicsBody?.contactTestBitMask = PhysicsCategory.player
				medPackCopy.physicsBody?.collisionBitMask = PhysicsCategory.none
			}
		}
		
		func addForceFieldUpgrade() {
			if let forceFieldUpgradeCopy = self.forceFieldUpgrade?.copy() as! SKShapeNode? {
				let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
				self.addChild(forceFieldUpgradeCopy)
				forceFieldUpgradeCopy.path = pathOfForceFieldUpgrade(rect, scaler: 2)
				let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
				let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
				forceFieldUpgradeCopy.position = CGPoint(x: actualX, y: actualY)
				let actionMove = SKAction.wait(forDuration: TimeInterval(10))
				let actionMoveDone = SKAction.removeFromParent()
				forceFieldUpgradeCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
				forceFieldUpgradeCopy.physicsBody = SKPhysicsBody(polygonFrom: pathOfForceFieldUpgrade(rect, scaler: 2))
				forceFieldUpgradeCopy.physicsBody?.categoryBitMask = PhysicsCategory.forceFieldUpgrade
				forceFieldUpgradeCopy.physicsBody?.contactTestBitMask = PhysicsCategory.player
				forceFieldUpgradeCopy.physicsBody?.collisionBitMask = PhysicsCategory.none
			}
		}
		
		func addMissileUpgrade() {
			if let missileUpgradeCopy = self.missileUpgrade?.copy() as! SKShapeNode? {
				let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
				self.addChild(missileUpgradeCopy)
				missileUpgradeCopy.path = pathOfMissileUpgrade(rect, scaler: 2)
				let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
				let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
				missileUpgradeCopy.position = CGPoint(x: actualX, y: actualY)
				let actionMove = SKAction.wait(forDuration: TimeInterval(10))
				let actionMoveDone = SKAction.removeFromParent()
				missileUpgradeCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
				missileUpgradeCopy.physicsBody = SKPhysicsBody(polygonFrom: pathOfMissileUpgrade(rect, scaler: 2))
				missileUpgradeCopy.physicsBody?.categoryBitMask = PhysicsCategory.missileUpgrade
				missileUpgradeCopy.physicsBody?.contactTestBitMask = PhysicsCategory.player
				missileUpgradeCopy.physicsBody?.collisionBitMask = PhysicsCategory.none
			}
		}

		func addPlayer() {
			let playerSize = CGRect(x: 0, y: 0, width: 1, height: 1)
			player.path = pathOfShip(playerSize, scaler: 2)
			player.fillColor = UIColor.black
			player.strokeColor = UIColor.green
			player.lineWidth = 3
			player.zPosition = 0.5
			let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
			let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
			player.position = CGPoint(x: actualX, y: actualY)
			player.physicsBody = SKPhysicsBody(polygonFrom: player.path!)
			player.physicsBody?.allowsRotation = false
			player.physicsBody?.linearDamping = 0
			player.physicsBody?.categoryBitMask = PhysicsCategory.player
			player.physicsBody?.collisionBitMask = PhysicsCategory.asteroid | PhysicsCategory.boundary | PhysicsCategory.enemy
			player.physicsBody?.contactTestBitMask = PhysicsCategory.medPack | PhysicsCategory.playerBullet | PhysicsCategory.enemyBullet
			addChild(player)
		}
		
		func addEnemy() {
			let enemySize = CGRect(x: 0, y: 0, width: 1, height: 1)
			enemy.path = pathOfShip(enemySize, scaler: 2)
			enemy.fillColor = UIColor.black
			enemy.strokeColor = UIColor.red
			enemy.lineWidth = 3
			enemy.zPosition = 0.3
			let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
			let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
			enemy.position = CGPoint(x: actualX, y: actualY)
			enemy.physicsBody = SKPhysicsBody(polygonFrom: enemy.path!)
			enemy.physicsBody?.allowsRotation = false
			enemy.physicsBody?.linearDamping = 0
			enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
			enemy.physicsBody?.collisionBitMask = PhysicsCategory.asteroid | PhysicsCategory.boundary | PhysicsCategory.player
			enemy.physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet
			addChild(enemy)
		}
		
		func addControls() {
			base.fillColor = UIColor.clear
			base.strokeColor = UIColor.white
			base.lineWidth = 2
			base.alpha = 0.2
			base.zPosition = 0.9
			ball.fillColor = UIColor.blue
			ball.strokeColor = UIColor.white
			ball.lineWidth = 0
			ball.glowWidth = 20
			ball.alpha = 0.4
			ball.zPosition = 1
			healthBar.fillColor = UIColor(displayP3Red: 0.7, green: 0.2, blue: 0.2, alpha: 0.7)
			healthBar.lineWidth = 0
			healthBar.zPosition = 1
			addChild(healthBar)
			leftSide.alpha = 0
			rightSide.alpha = 0
			addChild(leftSide)
			addChild(rightSide)
		}
		
		func addArrow() {
			arrow.strokeColor = UIColor.darkGray
			arrow.fillColor = UIColor.clear
			arrow.lineWidth = 4
			arrow.alpha = 0.4
			arrow.zPosition = 0.5
			addChild(arrow)
		}
		
		func pointAtPlayer() {
			let distX = (enemy.position.x) - (player.position.x)
			let distY = (enemy.position.y) - (player.position.y)
			if (enemy.position.x>player.position.x){
				enemy.zRotation = atan(distY/distX) + 1.57079633
			} else {
				enemy.zRotation = atan(distY/distX) - 1.57079633
			}
		}
		
		func moveToPlayer() {
			enemy.physicsBody?.velocity = CGVector(dx: 100*cos(enemy.zRotation+1.57079633), dy: 100*sin(enemy.zRotation+1.57079633))
		}
		
		func shootAtPlayer() {
			if let enemyBulletCopy = self.bullet?.copy() as! SKShapeNode? {
				self.addChild(enemyBulletCopy)
				let actionMove = SKAction.wait(forDuration: TimeInterval(2))
				let actionMoveDone = SKAction.removeFromParent()
				enemyBulletCopy.strokeColor = SKColor.red
				enemyBulletCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
				enemyBulletCopy.position.x = (enemy.position.x+(((enemy.frame.height/2)+6)*cos(CGFloat(enemy.zRotation)+1.57079633)))
				enemyBulletCopy.position.y = (enemy.position.y+(((enemy.frame.height/2)+6)*sin(CGFloat(enemy.zRotation)+1.57079633)))
				enemyBulletCopy.physicsBody?.velocity = CGVector(dx: 800*cos(enemy.zRotation+1.57079633), dy: 800*sin(enemy.zRotation+1.57079633))
				enemyBulletCopy.physicsBody?.categoryBitMask = PhysicsCategory.enemyBullet
				enemyBulletCopy.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
				enemyBulletCopy.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.player | PhysicsCategory.playerBullet | PhysicsCategory.forceField
				enemyShotsFired += 1
			}
		}
		
		enemy.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(pointAtPlayer), SKAction.run(moveToPlayer), SKAction.wait(forDuration: 0.01)])))
		enemy.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(shootAtPlayer), SKAction.wait(forDuration: 0.3)])))
		run(SKAction.sequence([SKAction.run(addPlayer), SKAction.run(addControls), SKAction.run(addEnemy), SKAction.run(addArrow)]))
		run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAsteroid), SKAction.wait(forDuration: 1.0)])))
		run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMedPack), SKAction.wait(forDuration: 3)])))
		run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addForceFieldUpgrade), SKAction.wait(forDuration: 3)])))
		run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMissileUpgrade), SKAction.wait(forDuration: 3)])))
	}
	
	func addExplosion(posX: CGFloat,posY: CGFloat) {
		let emitter = SKEmitterNode()
		emitter.position = CGPoint(x: posX, y: posY)
		emitter.particleAlpha = 0.9
		emitter.particleAlphaSpeed = -0.9
		emitter.particleSpeed = 100
		emitter.particleColorGreenRange = 1
		emitter.particleColor = UIColor.orange
		emitter.particleScaleRange = 1
		emitter.particleSpeedRange = 1
		emitter.particleSize = CGSize(width: 30, height: 30)
		emitter.emissionAngleRange = 10
		emitter.particleBirthRate = 30
		emitter.particleLifetime = 0.5
		emitter.numParticlesToEmit = 30
		addChild(emitter)
		let actionMove = SKAction.wait(forDuration: TimeInterval(1.5))
		let actionMoveDone = SKAction.removeFromParent()
		emitter.run(SKAction.sequence([actionMove, actionMoveDone]))
	}
	
	func killedEnemy() {
		let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
		let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
		addExplosion(posX: enemy.position.x, posY: enemy.position.y)
		enemy.removeFromParent()
		enemy.position = CGPoint(x: actualX, y: actualY)
		addChild(enemy)
		playerShotsHit += 1
	}
	

	func addForceField() {
		let forceFieldCopy = self.forceField?.copy() as! SKShapeNode?
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		self.addChild(forceFieldCopy!)
		forceFieldCopy?.path = pathOfForceField(rect, scaler: 50)
		forceFieldCopy?.position = CGPoint(x: player.position.x, y: player.position.y)
		func moveToPlayer() {
			forceFieldCopy?.run(SKAction.move(to: player.position, duration: 0.01))
		}
		let actionMove = SKAction.repeat(SKAction.sequence([SKAction.run(moveToPlayer), SKAction.wait(forDuration: 0.01)]), count: 400)
		let actionMoveDone = SKAction.removeFromParent()
		forceFieldCopy?.run(SKAction.sequence([actionMove, actionMoveDone]))
		forceFieldCopy?.physicsBody = SKPhysicsBody(edgeLoopFrom: pathOfForceField(rect, scaler: 50))
		forceFieldCopy?.physicsBody?.categoryBitMask = PhysicsCategory.forceField
		forceFieldCopy?.physicsBody?.contactTestBitMask = PhysicsCategory.enemyBullet | PhysicsCategory.playerBullet
		forceFieldCopy?.physicsBody?.collisionBitMask = PhysicsCategory.none
	}
	
	func addMissile() {
		let missileCopy = self.missile?.copy() as! SKShapeNode?
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		missileCopy?.path = pathOfMissile(rect, scaler: 2)
		missileCopy?.position = CGPoint(x: player.position.x, y: player.position.y)
		missileCopy?.physicsBody = SKPhysicsBody(polygonFrom: pathOfMissile(rect, scaler: 2))
		func pointAtEnemy() {
			let distX = (missileCopy?.position.x)! - (enemy.position.x)
			let distY = (missileCopy?.position.y)! - (enemy.position.y)
			if ((missileCopy?.position.x)!>enemy.position.x){
				missileCopy?.zRotation = atan(distY/distX) + 1.57079633
			} else {
				missileCopy?.zRotation = atan(distY/distX) - 1.57079633
			}
		}
		func moveToEnemy() {
			missileCopy?.physicsBody?.velocity = CGVector(dx: 300*cos((missileCopy?.zRotation)!+1.57079633), dy: 300*sin((missileCopy?.zRotation)!+1.57079633))
		}
		self.addChild(missileCopy!)
		let actionMove = SKAction.repeat(SKAction.sequence([SKAction.run(pointAtEnemy), SKAction.run(moveToEnemy), SKAction.wait(forDuration: 0.01)]), count: 400)
		let actionMoveDone = SKAction.removeFromParent()
		missileCopy?.run(SKAction.sequence([actionMove, actionMoveDone]))
		missileCopy?.physicsBody?.categoryBitMask = PhysicsCategory.missile
		missileCopy?.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
		missileCopy?.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.player | PhysicsCategory.enemyBullet | PhysicsCategory.forceField
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		if (contact.bodyA.categoryBitMask == PhysicsCategory.enemy && contact.bodyB.categoryBitMask == PhysicsCategory.playerBullet) {
			killedEnemy()
			contact.bodyB.node?.removeFromParent()
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.enemyBullet) {
			health -= 0.05
			contact.bodyB.node?.removeFromParent()
			enemyShotsHit += 1
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.forceField && contact.bodyB.categoryBitMask == PhysicsCategory.enemyBullet) {
			contact.bodyB.node?.removeFromParent()
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.enemy && contact.bodyB.categoryBitMask == PhysicsCategory.missile) {
			contact.bodyB.node?.removeFromParent()
			killedEnemy()
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.forceField && contact.bodyB.categoryBitMask == PhysicsCategory.playerBullet) {
			contact.bodyA.node?.removeFromParent()
		}
		
		if (contact.bodyA.categoryBitMask == PhysicsCategory.playerBullet && contact.bodyB.categoryBitMask == PhysicsCategory.enemyBullet) {
			contact.bodyA.node?.removeFromParent()
			contact.bodyB.node?.removeFromParent()
		}

		if (contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.medPack) {
			let medPackVisual = SKShapeNode(path: pathOfMedPack(CGRect(x: 0, y: 0, width: 1, height: 1), scaler: 2))
			medPackVisual.position = (contact.bodyB.node?.position)!
			contact.bodyB.node?.run(SKAction.removeFromParent())
			medPackVisual.lineWidth = 5
			medPackVisual.physicsBody?.categoryBitMask = PhysicsCategory.none
			addChild(medPackVisual)
			medPackVisual.run(SKAction.fadeOut(withDuration: 0.2))
			medPackVisual.run(SKAction.sequence([SKAction.scale(by: 1.3, duration: 0.2), SKAction.removeFromParent()]))
			health += 0.1
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.forceFieldUpgrade) {
			let forceFieldVisual = SKShapeNode(path: pathOfForceFieldUpgrade(CGRect(x: 0, y: 0, width: 1, height: 1), scaler: 2))
			forceFieldVisual.position = (contact.bodyB.node?.position)!
			contact.bodyB.node?.run(SKAction.removeFromParent())
			forceFieldVisual.lineWidth = 5
			forceFieldVisual.physicsBody?.categoryBitMask = PhysicsCategory.none
			addChild(forceFieldVisual)
			forceFieldVisual.run(SKAction.fadeOut(withDuration: 0.2))
			forceFieldVisual.run(SKAction.sequence([SKAction.scale(by: 1.3, duration: 0.2), SKAction.removeFromParent()]))
			addForceField()
		}
		if (contact.bodyA.categoryBitMask == PhysicsCategory.player && contact.bodyB.categoryBitMask == PhysicsCategory.missileUpgrade) {
			let missileVisual = SKShapeNode(path: pathOfMissileUpgrade(CGRect(x: 0, y: 0, width: 1, height: 1), scaler: 2))
			missileVisual.position = (contact.bodyB.node?.position)!
			contact.bodyB.node?.run(SKAction.removeFromParent())
			missileVisual.lineWidth = 5
			missileVisual.physicsBody?.categoryBitMask = PhysicsCategory.none
			addChild(missileVisual)
			missileVisual.run(SKAction.fadeOut(withDuration: 0.2))
			missileVisual.run(SKAction.sequence([SKAction.scale(by: 1.3, duration: 0.2), SKAction.removeFromParent()]))
			addMissile()
		}
		
	}
	
	func touchDownInRightSide(atPoint pos : CGPoint) {
		let playerBulletCopy = self.bullet?.copy() as! SKShapeNode
		self.addChild(playerBulletCopy)
		let actionMove = SKAction.wait(forDuration: TimeInterval(2))
		let actionMoveDone = SKAction.removeFromParent()
		playerBulletCopy.run(SKAction.sequence([actionMove, actionMoveDone]))
		playerBulletCopy.position.x = (player.position.x+(((player.frame.height/2)+6)*cos(CGFloat(player.zRotation)+1.57079633)))
		playerBulletCopy.position.y = (player.position.y+(((player.frame.height/2)+6)*sin(CGFloat(player.zRotation)+1.57079633)))
		playerBulletCopy.strokeColor = SKColor.green
		playerBulletCopy.physicsBody?.velocity = CGVector(dx: 800*cos(player.zRotation+1.57079633), dy: 800*sin(player.zRotation+1.57079633))
		playerBulletCopy.physicsBody?.categoryBitMask = PhysicsCategory.playerBullet
		playerBulletCopy.physicsBody?.collisionBitMask = PhysicsCategory.asteroid
		playerBulletCopy.physicsBody?.contactTestBitMask =  PhysicsCategory.enemy | PhysicsCategory.player | PhysicsCategory.enemyBullet | PhysicsCategory.forceField
		playerShotsFired += 1
	}
	
	func touchDownInLeftSide(atPoint pos : CGPoint) {
		addChild(base)
		addChild(ball)
		base.position = CGPoint(x: pos.x - (cam?.position.x)!, y: pos.y - (cam?.position.y)!)
		ball.position = CGPoint(x: pos.x - (cam?.position.x)!, y: pos.y - (cam?.position.y)!)
		touchMovedPos = pos
		baseTouchBeganPos = base.position
	}
	
	func touchMoveInLeftSide(toPoint pos : CGPoint) {
		ballTouchMovedPos.x = pos.x - (cam?.position.x)!
		ballTouchMovedPos.y = pos.y - (cam?.position.y)!
		
		let distX = (ball.position.x) - (base.position.x)
		let distY = (ball.position.y) - (base.position.y)
		if (ball.position.x>base.position.x){
			player.zRotation = atan(distY/distX) - 1.57079633
		} else {
			player.zRotation = atan(distY/distX) + 1.57079633
		}
		player.physicsBody?.velocity = CGVector(dx: (ball.position.x-base.position.x)*3, dy: (ball.position.y-base.position.y)*3)
		touchMovedPos = pos
	}

	var activeTouches:[SKShapeNode:UITouch] = [:]
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			if rightSide.frame.contains(location) && activeTouches[rightSide] == nil {
				touchDownInRightSide(atPoint: location)
				activeTouches[rightSide]=touch
			}
			
			if leftSide.frame.contains(location) && activeTouches[leftSide] == nil {
				touchDownInLeftSide(atPoint: location)
				activeTouches[leftSide]=touch
			}
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = activeTouches[leftSide], touches.contains(touch) {
			touchMoveInLeftSide(toPoint: touch.location(in: self))
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			if rightSide.frame.contains(location) {
				activeTouches[rightSide]=nil
			}
			if leftSide.frame.contains(location) {
				activeTouches[leftSide]=nil
				base.removeFromParent()
				ball.removeFromParent()
			}
		}
	}

	override func update(_ currentTime: TimeInterval) {
		if let camera = cam {
			let cameraWidth = 0.5*1500
			let cameraHeight = 0.281*1500
			let boundWidth = (CGFloat((scene?.frame.width)! - CGFloat(cameraWidth)))
			let boundHeight = (CGFloat((scene?.frame.height)! - CGFloat(cameraHeight)))
			let cameraLimit = CGRect(x: -boundWidth/2, y: -boundHeight/2, width: boundWidth, height: boundHeight)
			if (player.position.x<cameraLimit.minX) && (player.position.y>cameraLimit.maxY){
				camera.position.y = cameraLimit.maxY
				camera.position.x = cameraLimit.minX
			} else {
				if (player.position.x>cameraLimit.maxX) && (player.position.y>cameraLimit.maxY){
					camera.position.y = cameraLimit.maxY
					camera.position.x = cameraLimit.maxX
				} else {
					if (player.position.x>cameraLimit.maxX) && (player.position.y<cameraLimit.minY){
						camera.position.x = cameraLimit.maxX
						camera.position.y = cameraLimit.minY
					} else {
						if (player.position.x<cameraLimit.minX) && (player.position.y<cameraLimit.minY){
							camera.position.y = cameraLimit.minY
							camera.position.x = cameraLimit.minX
						} else {
							if (player.position.y>cameraLimit.maxY) {
								camera.position.x = player.position.x
								camera.position.y = cameraLimit.maxY
							} else {
								if (player.position.y<cameraLimit.minY) {
									camera.position.x = player.position.x
									camera.position.y = cameraLimit.minY
								} else {
									if (player.position.x>cameraLimit.maxX) {
										camera.position.y = player.position.y
										camera.position.x = cameraLimit.maxX
									} else {
										if (player.position.x<cameraLimit.minX) {
											camera.position.y = player.position.y
											camera.position.x = cameraLimit.minX
										} else {
											camera.position = player.position
										}
									}
								}
							}
						}
					}
				}
			}
		}
		

		base.position = CGPoint(x: ((cam?.position.x)! + baseTouchBeganPos.x),y: ((cam?.position.y)! + baseTouchBeganPos.y))

		let xDistX:CGFloat = 50
		let yDistY:CGFloat = 50
		
		if (touchMovedPos.x>base.position.x+xDistX) && (touchMovedPos.y>base.position.y+yDistY){
			ball.position = CGPoint(x: base.position.x+xDistX, y: (base.position.y+yDistY))
		} else {
			if (touchMovedPos.x<base.position.x-xDistX) && (touchMovedPos.y>base.position.y+yDistY) {
				ball.position = CGPoint(x: base.position.x-xDistX, y: (base.position.y+yDistY))
			} else {
				if (touchMovedPos.x<base.position.x-xDistX) && (touchMovedPos.y<base.position.y-yDistY) {
					ball.position = CGPoint(x:(base.position.x-xDistX), y: base.position.y-yDistY)
				} else {
					if (touchMovedPos.x>base.position.x+xDistX) && (touchMovedPos.y<base.position.y-yDistY) {
						ball.position = CGPoint(x: (base.position.x+xDistX), y: base.position.y-yDistY)
					} else {
						if (touchMovedPos.x>base.position.x+xDistX) {
							ball.position = CGPoint(x: base.position.x+xDistX, y: ((cam?.position.y)! + ballTouchMovedPos.y))
						} else {
							if (touchMovedPos.x<base.position.x-xDistX) {
								ball.position = CGPoint(x: base.position.x-xDistX, y: ((cam?.position.y)! + ballTouchMovedPos.y))
							} else {
								if (touchMovedPos.y>base.position.y+yDistY) {
									ball.position = CGPoint(x:((cam?.position.x)! + ballTouchMovedPos.x), y: base.position.y+yDistY)
								} else {
									if (touchMovedPos.y<base.position.y-yDistY) {
										ball.position = CGPoint(x: ((cam?.position.x)! + ballTouchMovedPos.x), y: base.position.y-yDistY)
									} else {
										ball.position = CGPoint(x: ((cam?.position.x)! + ballTouchMovedPos.x),y: ((cam?.position.y)! + ballTouchMovedPos.y))
									}
								}
							}
						}
					}
				}
			}
		}
		
		
		let distX = (enemy.position.x) - (player.position.x)
		let distY = (enemy.position.y) - (player.position.y)
		if (enemy.position.x>player.position.x){
			arrow.zRotation = atan(distY/distX) - 1.57079633
		} else {
			arrow.zRotation = atan(distY/distX) + 1.57079633
		}
		arrow.position.x = (player.position.x+(cos(arrow.zRotation+1.57079633)*30))
		arrow.position.y = (player.position.y+(sin(arrow.zRotation+1.57079633)*30))
		
		
		if (health>1) {
			health = 1
		}
		if (health<0) {
			addExplosion(posX: player.position.x, posY: player.position.y)
			let death = DeathScene(fileNamed: "DeathScene")
			death?.scaleMode = .aspectFill
			self.view?.presentScene(death!, transition: SKTransition.fade(withDuration: 0.5))

//			health = 1
//			let actualY = random(min: -self.frame.height/2+50, max: self.frame.height/2-50)
//			let actualX = random(min: -self.frame.width/2+50, max: self.frame.width/2-50)
//			player.position = CGPoint(x: actualX, y: actualY)
		}
		
		healthBar.xScale = health
		leftSide.position = CGPoint(x: (cam?.position.x)!-375, y: (cam?.position.y)!-500)
		rightSide.position = CGPoint(x: (cam?.position.x)!, y: (cam?.position.y)!-500)
		healthBar.position = CGPoint(x: (cam?.position.x)!-375, y: ((cam?.position.y)!+(0.281*750))-10)

		
		// Initialize _lastUpdateTime if it has not already been
		if (self.lastUpdateTime == 0) {
			self.lastUpdateTime = currentTime
		}
		// Calculate time since last update
		let dt = currentTime - self.lastUpdateTime
		
		timeElapsed += dt
		enemyDamageDealt = enemyShotsHit*5
		playerDamageDealt = playerShotsHit*5

		
		// Update entities
		for entity in self.entities {
			entity.update(deltaTime: dt)
		}
		self.lastUpdateTime = currentTime
	}
}

