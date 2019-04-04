//
//  GameScene.swift
//  Jeu
//
//  Created by virassamy brice on 28/03/2019.
//  Copyright © 2019 virassamy brice. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var ground = SKSpriteNode()
    private var bgVelocity:CGFloat = 3.0
    
    override func didMove(to view: SKView) {
        self.anchorPoint=CGPoint(x: 0, y: 0)
        addBackgrounds()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgrounds()
    }
    
    //[[ Creation et gestion mouvement du background
    
    func addBackgrounds(){
        for i in 0...3{
            let bg = SKSpriteNode(imageNamed: "Forest")
            bg.name="bg"
            bg.anchorPoint=CGPoint(x: 0, y: 0)
            bg.position=CGPoint(x: i * Int(bg.size.width), y: 0)
            
            
            self.addChild(bg)
        }
    }
    
    func moveBackgrounds(){
        self.enumerateChildNodes(withName: "bg", using: {(node, stop) -> Void in
            if let bg = node as? SKSpriteNode{
                bg.position = CGPoint(x: bg.position.x - self.bgVelocity, y: bg.position.y)
            
                if bg.position.x <= -bg.size.width{
                    bg.position = CGPoint(x: bg.position.x + bg.size.width*3, y: bg.position.y)
                }
            }
    })
    }
    
    
    //]]
    
    
}
