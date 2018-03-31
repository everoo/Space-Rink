//
//  GameViewController.swift
//  Space Arena
//
//  Created by Ever on 2/24/18.
//  Copyright © 2018 EvryGame. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		

		if let view = self.view as! SKView? {
			let menu = MenuScene(fileNamed: "MenuScene")
			menu?.scaleMode = .aspectFill
			view.presentScene(menu)
		}
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
