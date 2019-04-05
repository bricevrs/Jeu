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
    
    //perso
    private var perso = SKSpriteNode()
    
    //saut
    private let saut:CGVector = CGVector(dx: 0, dy: 400)
    
    
    //Physique de la scène
    private var bgVelocity:CGFloat = 5.0
    private var gravity:CGVector = CGVector(dx: 0, dy: -10)
    
    
    //Dimension scène
    private var sceneX:CGFloat = CGFloat()
    private var sceneY:CGFloat = CGFloat()
    
    //Dimension perso
    private var dimPerso:CGSize = CGSize(width: 102, height: 162)
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint=CGPoint(x: 0, y: 0)
        sceneX = self.size.width
        sceneY = self.size.height
        physicsWorld.gravity = gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        addBackgrounds()
        addPerso()
        perso.run(marcher())
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgrounds()
    }

    
    //[[  Creation personnage
    
    func addPerso(){
        perso = SKSpriteNode(imageNamed: "marche1")
        perso.name="perso"
        
        perso.zPosition=0
        perso.anchorPoint=CGPoint(x: 0, y: 0)
        perso.position=CGPoint(x: 150, y: 50)
        
        perso.size = dimPerso
        
        perso.physicsBody = SKPhysicsBody(rectangleOf: dimPerso)
        perso.physicsBody?.allowsRotation=false
        
        self.addChild(perso)
    }
    
    //[[ Annimation personnage
    func marcher() -> SKAction {
        var textures:[SKTexture] = []
        for i in 2...5 {
            textures.append(SKTexture(imageNamed: "marche\(i)"))
        }
        let annimMarche = SKAction.animate(with: textures, timePerFrame: 0.2)
        
        return annimMarche
    }
    
    
    //]]
    
    
    //Gestion des pressions sur écran
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let locY = touch.location(in: self).y
            let locX = touch.location(in: self).x
            
            //Gestion saut
            if (locY > (sceneY/2)) && (locX > (sceneX/2)) {
                print("saut")
                perso.physicsBody?.applyImpulse(saut)
            }
            
            //Gestion des frappes
            if (locY <= (sceneY/2)) {
                print("frappe")
                
            }
            
        }
    }
    
    
    
    //]]
    
    
    
    //[[ Creation et gestion mouvement du background
    
    func addBackgrounds(){
        for i in 0...3{
            let bg = SKSpriteNode(imageNamed: "Forest")
            bg.name="bg"
            bg.zPosition = -1
            bg.anchorPoint=CGPoint(x: 0, y: 0)
            bg.position=CGPoint(x: i * Int(bg.size.width), y: 0)
            
            self.addChild(bg)
            
            /*let ptfs = SKSpriteNode(imageNamed: "platforms")
            ptfs.name="ptfs"
            ptfs.zPosition = -1
            ptfs.anchorPoint=CGPoint(x: 0, y: 0)
            ptfs.position=CGPoint(x: i * Int(ptfs.size.width), y: 0)
            
            
            
            self.addChild(ptfs)*/
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
    
    
    

