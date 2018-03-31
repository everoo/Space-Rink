//
//  ADScene.swift
//  Space Arena
//
//  Created by Ever on 3/26/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

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


class AdScene: SKScene, GADRewardBasedVideoAdDelegate {
	private var lastUpdateTime : TimeInterval = 0
	var rewardBasedAd: GADRewardBasedVideoAd!
	
	func changeToMenuScene() {
		let menu = MenuScene(fileNamed: "MenuScene")
		menu?.scaleMode = .aspectFill
		self.view?.presentScene(menu!, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 0.5))
	}

	func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
		print("Reward received with currency: \(reward.type), amount \(reward.amount).")
		if staminaCount >= 20 {
			staminaCount = 20
		} else {
			staminaCount += 1
		}
	}
	
	func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
		print("Reward based video ad is received.")
		guard let controller = self.view?.window?.rootViewController as? GameViewController else {return}
		rewardBasedAd.present(fromRootViewController: controller)
	}
	
	func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
		print("Opened reward based video ad.")
	}
	
	func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
		print("Reward based video ad started playing.")
	}
	
	func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
		print("Reward based video ad has completed.")
		//changeToMenuScene()
	}
	
	func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
		print("Reward based video ad is closed.")
		changeToMenuScene()
	}
	
	func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
		print("Reward based video ad will leave application.")
	}
	
	func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
		print("Reward based video ad failed to load.")
		changeToMenuScene()
	}
	
	
	var entities = [GKEntity]()
	var graphs = [String : GKGraph]()
	
	override func didMove(to view: SKView) {
		
		rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
		rewardBasedAd.delegate = self
		//rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-2732851918745448/1874443128")
		let request = GADRequest()
		request.testDevices = [ "17755764fa910e4757b4728865f6217b" ]
		rewardBasedAd.load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
		self.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.4, blue: 0.4, alpha: 1)
	}
}



